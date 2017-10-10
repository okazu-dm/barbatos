#!/usr/bin/env ruby
$LOAD_PATH.push('../lib/')
require 'pp'

require 'barbatos'

counter = 0
get '/' do
  counter += 1
  render('sample.erb', count: counter)
end

get '/e' do
  puts self
  response.write(request.pretty_inspect)
end
