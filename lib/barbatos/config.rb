require 'singleton'
module Barbatos
  class Config
    include Singleton
    attr_reader :base_path, :views, :static

    def reset(base_path)
      @base_path = base_path
      @views = base_path + '/views'
      @static = base_path + '/static'
    end
  end
end
