require 'tilt'
require 'rack'
require 'forwardable'
require 'barbatos/response'
require 'singleton'

module Barbatos
  class App
    include Singleton
    attr_reader :request, :response

    def initialize
      self.class.show_routes
    end

    def call(env)
      process(env)
    end

    def process(env)
      @env = env
      @request = Rack::Request.new(env)
      @response = Barbatos::Response.new

      path = request.path
      request_method = request.request_method

      action = Barbatos::App.build_route(request_method, path)
      return response.not_found unless respond_to?(action)

      send(action)
      response
    end

    def render_text(text, status: 200, header: {})
      @response = Barbatos::Response.new(text.to_s, status, header)
    end

    def render(file, variables, status: 200, header: {})
      template = Tilt.new(file)
      render_text(
        template.render(self, variables),
        status: status,
        header: header
      )
    end

    def router
      self.class.router
    end

    class << self
      def router
        @router ||= {}
      end

      def call(env)
        instance.call(env)
      end

      # rubocop:disable Style/SingleLineMethods, Style/EmptyLineBetweenDefs
      def get(path, &block)     route 'GET', path, &block end
      def post(path, &block)    route 'POST', path, &block end
      def put(path, &block)     route 'GET', path, &block end
      def delete(path, &block)  route 'GET', path, &block end
      # rubocop:enable all

      def route(request_method, path, &block)
        route_text = build_route(request_method, path)
        router[route_text] = true # just for show routes
        define_method route_text, block
      end

      def build_route(request_method, path)
        [request_method, path].join('#')
      end

      def show_routes
        return if Barbatos.test?
        puts 'routing: '
        puts router.keys.map { |r| r.gsub('#', ' => ') }
      end

      def init
      end
    end
  end

  module Delegator
    extend Forwardable
    delegate [:get, :post, :put, :delete] => App
  end
end
