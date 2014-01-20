class User
  include Mongoid::Document
  include Tupplur::ModelExtensions

  rest_interface :create, 
                 :read, 
                 :update, 
                 :delete

  externally_accessible :name,
                        :email

  externally_readable :active

  field :name, type: String
  field :email, type: String
  field :password, type: String
  field :active, type: Boolean, default: false
end

