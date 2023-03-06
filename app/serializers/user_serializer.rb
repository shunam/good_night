class UserSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name
  has_many :friends, record_type: :user
end