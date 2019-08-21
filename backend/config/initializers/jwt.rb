require 'json_web_token'

Grape::Jwt::Authentication.configure do |conf|
  conf.authenticator = proc do |token|
    # Verify the token the way you like. (true, false)
    payload = JsonWebToken.decode(token)
    reponse = !payload.nil? && JsonWebToken.valid_payload(payload)
    reponse
  end

  conf.jwt_options = proc do
    # See: https://github.com/jwt/ruby-jwt
    { algorithm: 'HS256' }
  end
end
