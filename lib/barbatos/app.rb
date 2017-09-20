require 'tilt'
require 'rack'
require 'forwardable'
require 'barbatos/context'

module Barbatos
  class App
    @router = {}

    def initialize
    end

    def call(env)
      self.class.process(env)
    end

    class << self
      def process(env)
        @env = env
        @context = Barbatos::Context.new(env)
        path = @context.request.path
        request_method = @context.request.request_method
        action = @router[build_route(request_method, path)]
        return @context.not_found.response if action.nil?
        action.call(@context)
        @context.response
      end

      def render_text(text, status: 200, header: {})
        @context.response = Rack::Response.new(text.to_s, status, header)
      end

      def render(file, variables, status: 200, header: {})
        template = Tilt.new(file)
        render_text(template.render(self, variables), status: status, header: header)
      end

      # rubocop:disable Style/SingleLineMethods, Style/EmptyLineBetweenDefs
      def get(path, &block)     route 'GET', path, &block end
      def post(path, &block)    route 'POST', path, &block end
      def put(path, &block)     route 'GET', path, &block end
      def delete(path, &block)  route 'GET', path, &block end
      # rubocop:enable all

      def route(request_method, path, &block)
        @router ||= {}
        route_text = build_route(request_method, path)
        @router[route_text] = block
      end

      def build_route(request_method, path)
        [request_method, path].join('#')
      end
    end
  end

  module Delegator
    extend Forwardable
    delegate [:get, :post, :put, :delete] => App
    delegate [:render, :render_text] => App
  end
end
