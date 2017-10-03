require 'rack'

module Barbatos
  class Response < Rack::Response
    def not_found
      status!(404)
    end

    def forbidden
      status!(401)
    end

    def redirect(location, status_code = 302)
      super
      self
    end

    def status!(status_code)
      @status = status_code
      self
    end

    def body!(content)
      @body = content
      self
    end
  end
end
