class Secret
  include Tupplur::ModelExtensions
  include Mongoid::Document

  field :message, type: String
end

