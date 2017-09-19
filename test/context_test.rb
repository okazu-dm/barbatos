require 'test_helper'

class ContextTest < Minitest::Test
  def setup
    env = Rack::MockRequest.env_for('/')
    @context = Barbatos::Context.new(env)
  end

  def test_initialize
    assert_equal Rack::Request, @context.request.class
    assert_equal Rack::Response, @context.response.class
  end

  def test_status_codes
    assert_equal 404, @context.not_found.response.status
    assert_equal 401, @context.forbidden.response.status
    @context.status! 400
    assert_equal 400, @context.response.status
  end

  def test_body
    assert_equal 'hello', @context.body!('hello').response.body
  end
end
