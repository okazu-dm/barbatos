require 'tilt'
require 'rack'
require 'forwardable'

module Barbatos
  class App
    @router = {}

    def initialize
    end

    def call(env)
      req = Rack::Request.new(env)
      self.class.process(req)
    end

    class << self
      def render_text(text)
        Rack::Response.new(text.to_s)
      end

      def render(file, variables)
        template = Tilt.new(file)
        render_text(template.render(self, variables))
      end

      # rubocop:disable Style/SingleLineMethods, Style/EmptyLineBetweenDefs
      def get(path, &block) route 'GET', path, &block end
      def post(path, &block) route 'POST', path, &block end
      def put(path, &block) route 'GET', path, &block end
      def delete(path, &block) route 'GET', path, &block end
      # rubocop:enable all

      %w(401 404 500).each do |status|
        define_method("res_#{status}") { [status.to_i, {}, []] }
      end

      def process(req)
        path = req.path
        request_method = req.request_method
        action = @router[build_route(request_method, path)]
        return res_404 if action.nil?
        action.call(req)
      end

      def route(request_method, path, &block)
        route_text = build_route(request_method, path)
        @router[route_text] = block
      end

      def build_route(request_method, path)
        [request_method, path].join('#')
      end
    end
  end
end
