# Tupplur

Tupplur is a REST model import/export library for Rack applications using Mongoid. It's useful when building APIs for 
mobile or Single Page Applications (maybe using Backbone, Spine, AngularJS or 
whatever framework you prefer).

## Installation

Add this line to your application's Gemfile:

    gem 'tupplur'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tupplur

## Usage

Tupplur is divided into two parts: a model mixin and a Rack 
application which acts like a REST endpoint.

### REST endpoint Rack application
  Mount the Rack app on a route of your choice. The details of 
  how you do this will depend on which framework you're using.
  Each model gets its' own endpoint. So repeat this for all 
  models for which you want to provide a REST interface. 

  In Cuba:
    on "/users" do
      run Tupplur::RESTEndpoint.new(User)
    end

  Rack (in config.ru):
    run Rack::URLMap.new("/" => YourApp.new, 
                         "/users" => Tupplur::RESTEndpoint.new(User))

  If you're using Sinatra you might prefer the Rack method to mounting it 
  within Sinatra.

### Model mixin
In your model:
  include Tupplur::ModelExtensions

  This is where you define what parts of your model you want to 
  expose outside of your backend application. This is configured 
  in a similar manner to the way we choose to expose attributes on
  objects in plain Ruby. There you use atr_reader and 
  attr_accessor. Tupplur includes the corresponding methods 
  externally_readable and externally_accessible.

  You also define what REST operations a given model should 
  support using the rest_interface method.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
