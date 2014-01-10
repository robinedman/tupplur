require_relative "../../lib/tupplur"
require_relative "mock_mongoid_document"
require_relative "models/user"
require_relative "models/secret"

Cuba.define do
  on "users" do
    run Tupplur::RESTEndpoint.new(User)
  end

  on "secrets" do
    run Tupplur::RESTEndpoint.new(Secret)
  end
end
