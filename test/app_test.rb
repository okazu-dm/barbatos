require 'test_helper'

class AppTest < MiniTest::Test
  def setup
    TestWebApp.run(TestWebApp.instance)
    @app = TestWebApp.builder.to_app
  end

  class TestWebApp < Barbatos::App
    use Barbatos::TestMiddleware
    get '/' do
      render_text 'hello'
    end
  end

  def test_get
    request = Rack::MockRequest.new(@app)
    response = request.get('/')
    assert response.ok?
    assert_equal 'hello', response.body
  end

  def test_error_handling
    request = Rack::MockRequest.new(@app)
    response = request.get('/not_defined')
    assert_equal 404, response.status, 'Not found'
  end

  def test_builder
    request = Rack::MockRequest.new(@app)
    response = request.get('/')
    assert_equal '1', response.header[BARBATOS_TEST_HEADER]
  end
end
