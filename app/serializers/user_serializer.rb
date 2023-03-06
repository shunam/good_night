class UserSerializer
  include JSONAPI::Serializer
  attributes :name
  has_many :friends, record_type: :user, serializer: UserSerializer
end