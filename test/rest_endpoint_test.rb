require_relative "test_helper"
require_relative "../lib/tupplur"

module RESTEndPointTest
  class Base < TupplurTestCase
    def tabula_rasa
      User.delete_all
      Secret.delete_all
    end

    def setup
      tabula_rasa

      User.create!(name: "Adam", 
                   email: "adam@example.com",
                   password: "verysecurepassword")
      User.create!(name: "Brenda",
                   email: "brenda@example.com",
                   password: "verysecurepassword")

      Secret.create!(message: "Super secret info.")
    end

    def teardown
      tabula_rasa
    end
  end

  class GetTest < Base 
    test "get all documents returns only readable and accessible attributes" do
      get "/users"
    
      expected_response = [{name: "Adam", email: "adam@example.com", active: false},
                           {name: "Brenda", email: "brenda@example.com", active: false}]
      response = ActiveSupport::JSON.decode(last_response.body).map(&:symbolize_keys!)

      assert_equal(expected_response, response.map { |m| m.except(:_id, :id) })
    end

    test "get document with id returns only readable and accessible attributes" do
      brenda_id = User.find_by(name: "Brenda")._id
      get "/users/#{brenda_id}"

      expected_response = {name: "Brenda", email: "brenda@example.com", active: false}
      response = ActiveSupport::JSON.decode(last_response.body).symbolize_keys!

      assert_equal(expected_response, response.except(:_id, :id))
    end

    test "cannot get resource that does not allow it" do
      get "/secrets"

      assert_equal(401, last_response.status)
    end
  end

  class UpdateTest < Base
    test "update accessible attribute" do
      user = User.find_by(name: "Brenda")
      put "/users/#{user._id}", {data: {name: "Brian"}}
      user.reload

      assert_equal("Brian", user.name)
    end

    test "cannot update readonly attribute" do
      user = User.last
      put "/users/#{user._id}", {data: {active: true}}
      user.reload

      refute(user.active)
    end

    test "cannot update internal attribute" do
      user = User.last
      put "users/#{user._id}", {data: {password: "anotherpassword"}}
      user.reload

      assert_equal("verysecurepassword", user.password)
    end

    test "cannot update resource that does not allow it" do
      secret = Secret.first
      put "secrets/#{secret._id}", {data: {message: "I say"}}
      secret.reload

      assert_equal("Super secret info.", secret.message)
    end
  end

  class DeleteTest < Base
    test "delete resource" do
      user_id = User.first._id
      delete "/users/#{user_id}"

      refute(User.find(user_id))
    end

    test "cannot delete resource that does not allow it" do
      secret_id = Secret.first._id
      delete "/secrets/#{secret_id}"

      assert(Secret.find(secret_id))
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
