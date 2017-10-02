require 'tilt'
require 'rack'
require 'forwardable'
require 'barbatos/context'
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
      @context = Barbatos::Context.new(env)
      path = @context.request.path
      request_method = @context.request.request_method

      action = Barbatos::App.build_route(request_method, path)
      return @context.not_found.response unless respond_to?(action)

      if method(action).arity > 0
        send(action, @context)
      else
        send(action)
      end
      @context.response
    end

    def render_text(text, status: 200, header: {})
      @context.response = Rack::Response.new(text.to_s, status, header)
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

      # def res_404(text = '') Rack::Response.new(text.to_s, 404) end

      %w(401 404 500).each do |status|
        define_method("res_#{status}") { [status.to_i, {}, []] }
      end

      def process(req)
        path = req.path
        request_method = req.request_method
        action = router[build_route(request_method, path)]
        return res_404 if action.nil?
        action.call(req)
      end

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
