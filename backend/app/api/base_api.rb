class BaseAPI < Grape::API
    mount Versions::V1
end