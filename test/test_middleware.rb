module Barbatos
  # Just set header for assertion
  class TestMiddleware
    def initialize(app, header_key = BARBATOS_TEST_HEADER)
      @app = app
      @header_key = header_key
    end

    def call(env)
      response = @app.call(env)
      response.header[@header_key] = '1'
      response
    end
  end
end
