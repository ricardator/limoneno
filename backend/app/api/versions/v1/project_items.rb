require 'json_web_token'
module Versions
  class V1::ProjectItems < Grape::API
    version 'v1', using: :path
    format :json

    include Grape::Jwt::Authentication
    auth :jwt

    route_param :projects_id do
      namespace :items do
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
          Dataset.all
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
end