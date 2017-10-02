require 'test_helper'

class AppTest < MiniTest::Test
  class TestWebApp < Barbatos::App
    get '/' do |env|
      render_text 'hello'
    end

    get '/no_arity' do
      render_text 'no arity'
    end
  end

  def setup
    @app = TestWebApp.instance
  end

  def test_get
    request = Rack::MockRequest.new(@app)
    response = request.get('/')
    assert response.ok?
    assert_equal 'hello', response.body

    response = request.get('/no_arity')
    assert response.ok?
  end

  def test_error_handling
    request = Rack::MockRequest.new(@app)
    response = request.get('/not_defined')
    assert_equal 404, response.status, 'Not found'
  end

end
