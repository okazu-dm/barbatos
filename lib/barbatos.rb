require 'barbatos/version'
require 'barbatos/app'
require 'barbatos/config'

module Barbatos
  @app_filepath = File.expand_path caller(1)
                  .map { |path| path.split(':')[0] }
                  .reject { |path| %r{barbatos(?!/example|/test)|kernel_require} =~ path }.first

  Barbatos::Config.instance.reset(File.dirname(@app_filepath))

  def self.invoke_by_appfile?
    invoked_filepath = File.expand_path($PROGRAM_NAME)
    invoked_filepath == @app_filepath
  end

  def self.env
    (ENV['BARBATOS_ENV'] || ENV['RACK_ENV'] || :development).to_sym
  end

  def self.dev?
    env == :development
  end

  def self.test?
    env == :test
  end

  def self.productionn?
    env == :productionn
  end
end

extend Barbatos::Delegator

at_exit do
  Rack::Server.start app: Barbatos::App.instance if
    Barbatos.invoke_by_appfile? && !Barbatos.test?
end
