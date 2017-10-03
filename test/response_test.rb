require 'test_helper'

class ResponseTest < Minitest::Test
  def setup
    env = Rack::MockRequest.env_for('/')
    @response = Barbatos::Response.new(env)
  end

  def test_status_codes
    assert_equal 404, @response.not_found.status
    assert_equal 401, @response.forbidden.status
    @response.status! 400
    assert_equal 400, @response.status
  end

  def test_body
    assert_equal 'hello', @response.body!('hello').body
  end

  def test_redirect
    @response.redirect('/redirected')
    assert_equal '/redirected', @response.headers['location'], 'redirect path'
    assert_equal 302, @response.status, 'default status code is 302'
    @response.redirect('/redirected', 301)
    assert_equal 301, @response.status, 'set status code'
  end
end
