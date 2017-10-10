$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'barbatos'
require 'rack'
require 'minitest/autorun'
require 'test_middleware'

BARBATOS_TEST_HEADER = 'barbatos.test'.freeze
ENV['BARBATOS_ENV'] = 'test'
