require 'test_helper'

class RouterTest < Minitest::Test
  def setup
    @router = Barbatos::Router.new
    @router.route(
      'Get', '/', self.class.generate_unbound_method { puts 'test' }
    )
  end

  def test_show_routes
    expected = <<EOF
routing:
GET\t/
EOF
    assert_output(expected) { @router.show_routes }
  end

  def test_fetch_action
    action = proc {}
    @router.route('post', '/post', action)
    # assert fetcheing exactly same method
    assert_equal(
      action.object_id, @router.fetch_action('post', '/post').object_id
    )
  end

  def self.generate_unbound_method(&block)
    define_method('__test_unbound_method__', &block)
    unbound_method = instance_method('__test_unbound_method__')
    remove_method('__test_unbound_method__')
    return unbound_method
  end
end
