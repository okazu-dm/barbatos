#!/usr/bin/env ruby
$LOAD_PATH.push('../lib/')

require 'barbatos'

# class WebApp < Barbatos::App
counter = 0

get '/' do |req|
  counter += 1
  render('sample.erb', count: counter)
end
# end
