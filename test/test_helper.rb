require "turn/autorun"
require "active_support/all"
require "rack/test"
require_relative "test_app/app"

Turn.config.natural = true

class TupplurTestCase < ActiveSupport::TestCase
  include Rack::Test::Methods

  def app
    Cuba
  end
end
