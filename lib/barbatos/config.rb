require 'singleton'
module Barbatos
  class Config
    attr_reader :base_path, :views, :static

    def initialize(base_path)
      @base_path = base_path
      @views = base_path + '/views/'
      @static = base_path + '/static/'
    end
  end
end
