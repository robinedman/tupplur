require "mongoid"
require_relative "helpers"

cd_to_here
Mongoid.load!("./mongoid.yml")

require_relative "../../lib/tupplur"
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

