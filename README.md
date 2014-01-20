# Tupplur

Tupplur extends your Mongoid 3.x models, allowing you to expose fields as readable 
or writable from outside of your application. It includes a Rack REST adapter, 
so that any Rack app can expose some or all of its' models as JSON easily 
through a standard REST CRUD api. 

This library is especially useful if you're building APIs for mobile or 
Single Page Applications (maybe using Backbone, Spine, AngularJS or whichever 
framework you prefer).

It's been designed to work well straight on top of Rack, or with lightweight 
Rack-based frameworks such as Sinatra and Cuba. In fact, the REST adapter is 
implemented as a Cuba application.

If you're using Rails you're probably better off with another solution at the 
moment, since it might make more sense to use something that's more 
integrated into the framework.

## Installation

Add this line to your application's Gemfile:

    gem 'tupplur'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tupplur

If necessary in your application:
    `require 'tupplur'` at the appropriate place.

## Usage

Tupplur is divided into two parts: a model mixin and a Rack 
application which acts like a REST endpoint.

### REST endpoint Rack application
  After Mongoid has been set up, mount the Rack app on a route of your choice. 
  The details of how you do this will depend on which framework you're using.
  Each model gets its' own endpoint. So repeat this for all 
  models for which you want to provide a REST interface.

  In Cuba:
  ```ruby
  on "/users" do 
    run Tupplur::RESTEndpoint.new(User)
  end
  ```
      
  In Rack (in config.ru):
  ```ruby
  run Rack::URLMap.new("/" => YourApp.new, 
                       "/users" => Tupplur::RESTEndpoint.new(User))
  ```
  
  If you're using Sinatra you might prefer the Rack method to mounting it 
  within Sinatra itself.

### Model mixin
In your model:
  ```ruby
  class User
    include Mongoid::Document
    include Tupplur::ModelExtensions
   
    # The operations you want to support.
    rest_interface :create, 
                   :read, 
                   :update, 
                   :delete
    
    # Fields that are to be both readable and writable.
    externally_accessible :name,
                          :email
    
    # Read-only fields.
    externally_readable :active
    
    # Put your regular Mongoid model code here 
    # (or anywhere you want to as the ordering doesn't matter).
    field :name, type: String
    field :email, type: String
    field :password, type: String
    field :active, type: Boolean, default: false
  end
  ```
  This is where you define what parts of your model you want to 
  expose outside of your backend application. This is configured 
  in a similar manner to the way we choose to expose attributes on
  objects in plain Ruby. There we use `attr_reader` and 
  `attr_accessor`. Tupplur includes the corresponding methods 
  `externally_readable` and `externally_accessible`.

  You also define what REST operations a given model should 
  support using the `rest_interface method`. Just like `externally_readable` and 
  `externally_writable` it takes one or more symbols as arguments: `:create, :read,
  :update, :delete`. The default is to not support any operation.

### Examples
In the test directory you'll find an example app which uses the Cuba framework.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
