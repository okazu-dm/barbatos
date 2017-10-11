require 'test_helper'

get '/reseted' do
  render_text 'only_in_base_class'
end

class AppTest < MiniTest::Test
  def setup
    TestWebApp.run(TestWebApp.instance)
    @app = TestWebApp.builder.to_app
    Barbatos::App.run(Barbatos::App.instance)
    @base_app = Barbatos::App.builder.to_app

    @request = Rack::MockRequest.new(@app)
    @base_class_request = Rack::MockRequest.new(@base_app)
  end

  class TestWebApp < Barbatos::App
    use Barbatos::TestMiddleware
    get '/' do
      render_text 'hello'
    end

    get '/template' do
      render 'test_template.erb', test_var: 'hello'
    end
  end

  def test_get
    response = @request.get('/')
    assert response.ok?
    assert_equal 'hello', response.body
    response = @request.get('/template')
    assert_equal "test_var:hello\n", response.body
  end

  # check isolation between Base class and Subclass
  def test_reset
    response = @request.get('/reseted')
    assert !response.ok?
    assert_equal 404, response.status, 'Base class routing should be reset'

    base_class_response = @base_class_request.get('/reseted')
    assert base_class_response.ok?
    assert_equal 'only_in_base_class', base_class_response.body
  end

  def test_error_handling
    response = @request.get('/not_defined')
    assert_equal 404, response.status, 'Not found'
  end

  def test_builder
    response = @request.get('/')
    assert_equal '1', response.header[BARBATOS_TEST_HEADER]
  end
end
