require 'test_helper'

class AppTest < MiniTest::Test
  class TestWebApp < Barbatos::App
    get '/' do |env|
      render_text 'hello'
    end
  end

  def setup
    @app = TestWebApp.new
  end

  def test_get
    request = Rack::MockRequest.new(@app)
    response = request.get('/')
    assert response.ok?
    assert_equal 'hello', response.body
  end

end
