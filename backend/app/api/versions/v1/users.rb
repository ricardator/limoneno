require 'json_web_token'
module Versions
  class V1::Users < Grape::API
    version 'v1', using: :path
    format :json

    namespace :users do
      # LOGIN USER METHOD
      post :login do
        email = params[:email]
        password = params[:password]

        user = User.find_by_email(email)
        if user && user.authenticate(params[:password])
          status 200
          user_json = user.to_json
          token = JsonWebToken.encode(user_json)

          {
            token: token,
            user: user
          }
        else
          status 401
        end

        rescue
          puts 500
      end

      include Grape::Jwt::Authentication
      auth :jwt

      # CREATE USER METHOD
      params do
        requires :name, :email, :password, :admin
      end
      post do
        name = params[:name]
        email = params[:email]
        password = params[:password]
        admin = params[:admin]

        user = User.create({
          name: name,
          email: email,
          password: password,
          admin: admin
        })

        user
      rescue
        status 500
      end

      # UPDATE USER METHOD
      params do
        requires :id, :name, :email, :admin
      end
      patch do
        id = params[:id]
        name = params[:name]
        email = params[:email]
        password = params[:password]
        admin = params[:admin]

        User.update(id, {
          name: name,
          email: email,
          admin: admin
        })

        if (password)
          User.update(id, {
            password: password
          })
        end

        status 204
      rescue
        status 500
      end

      # DELETE USER METHOD
      delete ':id' do
        id = params[:id]

        User.find(id).delete

        status 204
      end

      # AUTHENTICATED STATE USER METHOD
      get :me do
        user = JsonWebToken.get_payload(headers)
        user
      end

      get do
        User.all
      end
    end
  end
end