class Secret
  include Mongoid::Document
  include Tupplur::ModelExtensions

  field :message, type: String
end

