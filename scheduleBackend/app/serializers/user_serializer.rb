class UserSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :name, :email
  has_many :tasks
end