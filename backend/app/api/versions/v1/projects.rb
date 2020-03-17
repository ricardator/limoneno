# frozen_string_literal: true

require 'json_web_token'
module Versions
  class V1::Projects < Grape::API
    version 'v1', using: :path
    format :json

    include Grape::Jwt::Authentication
    auth :jwt

    namespace :projects do
      # CREATE DATASET METHOD
      params do
        requires :name
      end
      post do
        datasets = Dataset.find(params[:datasets])
        users = User.find(params[:users])

        project = Project.create(
          name: params[:name],
          description: params[:description],
          clasification_type: params[:clasification_type],
          entities: params[:entities],
          clasifications: params[:clasifications],
          datasets: datasets,
          users: users,
          status: 1
        )

        project = params[:datasets]
        users = params[:users]

        status 201
        project
      rescue StandardError => e
        puts e
        status 500
      end

      # UPDATE DATASET METHOD
      params do
        requires :id, :name
      end
      patch do
        id = params[:id]
        name = params[:name]
        datasets = Dataset.find(params[:datasets])
        users = User.find(params[:users])

        Project.update(id,
                       name: params[:name],
                       description: params[:description],
                       clasification_type: params[:clasification_type],
                       entities: params[:entities],
                       clasifications: params[:clasifications],
                       datasets: datasets,
                       users: users,
                       status: 1)

        status 204
      end

      # DELETE DATASET METHOD
      delete ':id' do
        Project.destroy(params[:id])

        status 204
      end

      get do
        project_ids = Project.all.pluck(:id)
        projects = project_ids.map do |id|
          Project.with_dependencies(id)
        end

        projects
      end

      # GET UNIQUE PROJECT
      get ':id' do
        project = Project.with_dependencies(params[:id])
      end

      route_param :project_id do
        params do
          requires :project_id, type: Integer, desc: 'Project id'
          requires :users_pool, type: Hash, desc: 'pool assigned to users'
        end
        post :assign_pool do
          project_id = params[:project_id]
          users_pool = params[:users_pool]
          ProjectDatasetItem.create_users_pool(users_pool, project_id)

          status 200
          Project.with_dependencies(project_id)
        end
      end

      mount V1::ProjectItems
    end

    namespace :users do
      route_param :user_id do
        namespace :projects do
          get do
            user = params[:user_id]

            projects = ProjectUser.where(
              user_id: user
            ).includes(:project)

            projects_stats = projects.map do |project|
              tmp = Project.where(id: project.project_id).includes(:users).first.attributes

              tmp[:assignated] = ProjectDatasetItem.where(
                project_id: project.project_id,
                user_id: user,
                status: [0, -1]
              ).count(:id)

              tmp[:assignated_done] = ProjectDatasetItem.where(
                project_id: project.project_id,
                user_id: user,
                status: 1
              ).count(:id)

              tmp[:free_pool_done] = ProjectDatasetItem.where(
                project_id: project.project_id,
                user_id: user,
                status: 2
              ).count(:id)

              tmp[:free_pool] = project.project.free_pool(user).count(:dataset_id)

              tmp
            end

            status 200
            projects_stats
          end

          route_param :project_id do
            namespace :workout do
              get do
                assignated = ProjectDatasetItem.where(
                  user_id: params[:user_id],
                  project_id: params[:project_id],
                  status: [0, -1]
                ).includes(:dataset, :dataset_item).first
                # Get From free pool if
                if assignated
                  status 200
                  return assignated.as_json(include: %i[dataset dataset_item])
                else
                  free_item = Project.find(params[:project_id]).free_pool(params[:user_id]).first

                  if free_item
                    created = ProjectDatasetItem.create(
                      user_id: params[:user_id],
                      project_id: params[:project_id],
                      status: -1,
                      dataset_id: free_item.dataset_id,
                      dataset_item_id: free_item.id
                    )

                    assignated = ProjectDatasetItem.where(
                      id: created.id
                    ).includes(:dataset, :dataset_item).first

                    status 200
                    assignated.as_json(include: %i[dataset dataset_item])
                  else
                    status 404
                  end
                end
              end

              patch ':id' do
                id = params[:id]
                tags = params[:tags]

                clasification = ProjectDatasetItem.update(id,
                                                          clasification: params[:clasification],
                                                          tags: params[:tags],
                                                          status: params[:status] == -1 ? 2 : 1,
                                                          documents: params[:documents])

                # True if "multiples actuaciones"
                if params[:documents]
                  dataset = DatasetItem.find_by(id: params[:datasetItem][:id])
                  tags.each do |document|
                    document = dataset[:text][document[:start], document[:end]]
                    # Creamos el dataset
                    item = DatasetItem.create(
                      raw_text: document,
                      dataset_id: dataset[:dataset_id],
                      name: dataset[:name],
                      mime: dataset[:mime],
                      metadata: dataset[:metadata],
                      url: dataset[:url],
                      status: dataset[:status]
                    )
                    # Asignamos el nuevo documento al usuario
                    ProjectDatasetItem.create(
                      user_id: params[:user_id],
                      project_id: params[:project_id],
                      clasification: params[:clasification],
                      status: -1,
                      dataset_id: dataset[:dataset_id],
                      dataset_item_id: item.id
                    )
                  end
                end

                clasification.status = 2

                status 200
                clasification
              end
            end
          end
        end
      end
    end
  end
end
