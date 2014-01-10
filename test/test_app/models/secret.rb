class Secret
  include Tupplur::ModelExtensions
  include MockMongoidDocument

  attribute :message, String
end

