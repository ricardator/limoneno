require 'json_web_token'
module Versions
  class V1::Datasets < Grape::API
    version 'v1', using: :path
    format :json

    include Grape::Jwt::Authentication
    auth :jwt

    namespace :datasets do
      # CREATE DATASET METHOD
      params do
        requires :name
      end
      post do
        name = params[:name]

        dataset = Dataset.create({
          name: name
        })

        dataset
      rescue
        status 500
      end

      # UPDATE DATASET METHOD
      params do
        requires :id, :name
      end
      patch do
        id = params[:id]
        name = params[:name]

        Dataset.update(id, {
          name: name
        })

        status 204
      rescue
        status 500
      end

      # DELETE DATASET METHOD
      delete ':id' do
        id = params[:id]

        Dataset.destroy(id)

        status 204
      end


      get do
        Dataset
        .left_outer_joins(:dataset_items)
        .group("datasets.id")
        .select("datasets.*, COUNT(dataset_items.dataset_id) AS items_count")
        .all
      end
      
      get 'active'do
        Dataset
        .left_outer_joins(:dataset_items)
        .group("datasets.id")
        .select("datasets.*, COUNT(dataset_items.dataset_id) AS items_count")
        .where("dataset_items.status = 1")
        .all
      end

      # GET UNIQUE DATASET
      get ':id' do
        id = params[:id]

        dataset = Dataset.where({
          id: id
        }).includes(:dataset_items)
        .as_json(include: :dataset_items).first

        present dataset
      end

      mount V1::DatasetItems
    end
  end
end