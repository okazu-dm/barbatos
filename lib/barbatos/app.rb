require 'tilt'
require 'rack'
require 'pathname'
require 'singleton'
require 'forwardable'
require 'barbatos/response'
require 'barbatos/router'
require 'barbatos/config'

module Barbatos
  class App
    include Singleton
    attr_reader :request, :response

    def call(env)
      process(env)
    end

    def process(env)
      @env = env
      @request = Rack::Request.new(env)
      @response = Barbatos::Response.new

      call_action_method

      response
    end

    def call_action_method
      path = request.path
      request_method = request.request_method

      # fetch unbound method
      action = router.fetch_action(request_method, path)
      return response.not_found if action.nil?
      action.bind(self).call
    end

    def render_text(text, status: 200, header: {})
      @response = Barbatos::Response.new(text.to_s, status, header)
    end

    def render(file_name, variables, status: 200, header: {})
      template = generate_template(file_name)
      render_text(
        template.render(self, variables),
        status: status,
        header: header
      )
    end

    def generate_template(file_name)
      return Tilt.new(file_name) if Pathname(file_name).absolute?
      Tilt.new(config.views + file_name)
    end

    def router
      self.class.router
    end

    def config
      self.class.config
    end

    class << self
      extend Forwardable

      def new(*args)
        show_routes
        builder.run(super)
      end

      def clear!
        @router = nil
        @builder = nil
        @config = nil
      end

      def router
        @router ||= Barbatos::Router.new
      end

      def call(env)
        instance.call(env)
      end

      def config
        @config ||= init_config
      end

      def init_config(base_path = Barbatos.app_filepath)
        @config = Barbatos::Config.new(File.dirname(base_path))
      end

      def builder
        @builder ||= Rack::Builder.new
      end

      # rubocop:disable Style/SingleLineMethods, Style/EmptyLineBetweenDefs
      def get(path, &block)     route 'GET', path, &block end
      def post(path, &block)    route 'POST', path, &block end
      def put(path, &block)     route 'GET', path, &block end
      def delete(path, &block)  route 'GET', path, &block end
      # rubocop:enable all

      def route(request_method, path, &block)
        unbound_insance_method = generate_unbound_method(&block)
        router.route(request_method, path, unbound_insance_method)
      end

      def generate_unbound_method(&block)
        method_name = "__#{self}__unbound_method__"
        define_method(method_name, &block)
        unbound_method = instance_method(method_name)
        remove_method(method_name)
        return unbound_method
      end

      def show_routes
        router.show_routes if Barbatos.dev?
      end

      private

      def inherited(klass)
        super
        # reset routing and middleware stack
        klass.clear!
      end

      delegate [:use, :run, :to_app] => :builder
    end
  end

  module Delegator
    extend Forwardable
    delegate [:get, :post, :put, :delete, :use, :run] => App
  end
end
