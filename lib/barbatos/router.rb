module Barbatos
  class Router
    def initialize
      @routes = {}
    end

    def route(request_method, path, unbound_method)
      routing_name = build_route(request_method, path)
      @routes[routing_name] = unbound_method
    end

    def fetch_action(request_method, path)
      routing_name = build_route(request_method, path)
      @routes[routing_name]
    end

    def build_route(request_method, path)
      [request_method.upcase, path].join('#')
    end

    def show_routes
      puts 'routing:'
      puts @routes.keys.map { |r| r.tr('#', "\t") } unless @routes.empty?
    end
  end
end
