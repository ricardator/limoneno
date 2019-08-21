require 'json_web_token'

class Users::API < Grape::API
  format :json

  params do
    requires :name, :mail, :password
  end
  post :register do
    name = params[:name]
    email = params[:mail]
    password = params[:password]
    
    User.create({
      name: name,
      email: email,
      password: password,
      admin: 0
    })

    {
      name: name,
      email: email,
      password: password
    }
  end

  post :login do
    email = params[:email]
    password = params[:password]

    user = User.find_by_email(email)
    if user && user.authenticate(params[:password])
      status 200
      user = user.to_json
      user.delete("password_digest")
      puts user
      token = JsonWebToken.encode(user)

      {
        token: token
      }
    else
      status 401
    end
  end

  include Grape::Jwt::Authentication
  auth :jwt

  get :me do
    user = JsonWebToken.get_payload(headers)
    user
  end

  get do
    User.all
  end
end