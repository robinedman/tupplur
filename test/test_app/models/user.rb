class User
  include Tupplur::ModelExtensions
  include MockMongoidDocument

  rest_interface :create, 
                 :read, 
                 :update, 
                 :delete

  externally_accessible :name,
                        :email

  externally_readable :active

  attribute :name, String
  attribute :email, String
  attribute :password, String
  attribute :active, Boolean, default: false
end

