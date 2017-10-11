require 'test_helper'

class ConfigTest < Minitest::Test
  def setup
    @config = Barbatos::Config.instance
  end

  def test_reset
    prefix = '/root/app/'
    @config.reset(prefix)
    assert_equal prefix, @config.base_path
    assert_equal prefix + '/views', @config.views
    assert_equal prefix + '/static', @config.static
  end
end
