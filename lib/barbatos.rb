require 'barbatos/version'
require 'barbatos/app'

module Barbatos
  # Your code goes here...
end

extend Barbatos::Delegator

at_exit {Rack::Server.start :app => Barbatos::App.new}
