class User < ApplicationRecord

    validates :email, presence: true, uniqueness: true
    validates :name, presence: true
    has_secure_password

    def to_json(options={})
     options[:except] ||= [:password_digest, :created_at, :updated_at]
     super(options)
    end
end
