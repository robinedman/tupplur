require_relative "test_helper"
require_relative "../lib/tupplur"

module RESTEndPointTest
  class Base < TupplurTestCase
    def setup
      User.create!(name: "Adam", 
                   email: "adam@example.com",
                   password: "verysecurepassword")
      User.create!(name: "Brenda",
                   email: "brenda@example.com",
                   password: "verysecurepassword")

      Secret.create!(message: "Super secret info.")
    end

    def teardown
      User.all.clear
      Secret.all.clear
    end
  end

  class GetTest < Base 
    test "get all documents returns only readable and accessible attributes" do
      get "/users"
    
      expected_response = [{name: "Adam", email: "adam@example.com", active: false, _id: "0", id: "0"},
                           {name: "Brenda", email: "brenda@example.com", active: false, _id: "1", id: "1"}]
      response = ActiveSupport::JSON.decode(last_response.body).map(&:symbolize_keys!)

      assert_equal(expected_response, response)
    end

    test "get document with id returns only readable and accessible attributes" do
      get "/users/1"

      expected_response = {name: "Brenda", email: "brenda@example.com", active: false, _id: "1", id: "1"}
      response = ActiveSupport::JSON.decode(last_response.body).symbolize_keys!

      assert_equal(expected_response, response)
    end

    test "cannot get resource that does not allow it" do
      get "/secrets"

      assert_equal(401, last_response.status)
    end
  end

  class UpdateTest < Base
    test "update accessible attribute" do
      put "/users/1", {data: {name: "Brian"}}

      assert_equal("Brian", User.find("1").name)
    end

    test "cannot update readonly attribute" do
      put "/users/1", {data: {active: true}}

      refute(User.find("1").active)
    end

    test "cannot update internal attribute" do
      put "users/1", {data: {password: "anotherpassword"}}

      assert_equal("verysecurepassword", User.find("1").password)
    end

    test "cannot update resource that does not allow it" do
      put "secrets/0", {data: {message: "I say"}}

      assert_equal("Super secret info.", Secret.find("0").message)
    end
  end

  class DeleteTest < Base
    test "delete resource" do
      delete "/users/0"

      refute(User.find("0"))
    end

    test "cannot delete resource that does not allow it" do
      delete "/secrets/0"

      assert(Secret.find("0"))
    end
  end

  class CreateTest < Base
    test "create resource" do
      post "/users", {data: {name: "Charles", email: "charles@example.com"}}

      assert(User.find_by(name: "Charles"))
    end

    test "cannot set readable attributes" do
      post "/users", {data: {name: "Roger", active: true}}

      refute(User.find_by(name: "Roger").active)
    end

    test "cannot create resource that does not allow it" do
      post "/secrets", {data: {message: "Hey"}}

      refute(Secret.find_by(message: "Hey"))
    end
  end
end
