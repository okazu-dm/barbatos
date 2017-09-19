$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'barbatos'
require 'rack'
require 'minitest/autorun'


ENV['BARBATOS_ENV'] = 'test'
