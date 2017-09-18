require 'barbatos/version'
require 'barbatos/app'

module Barbatos
  # Your code goes here...
  @app_filepath = File.expand_path caller(1)
                  .map { |path| path.split(':')[0] }
                  .reject { |path| /barbatos|kernel_require/ =~ path }.first
  def self.invoke_by_appfile?
    invoked_filepath = File.expand_path($PROGRAM_NAME)
    invoked_filepath == @app_filepath
  end
end

extend Barbatos::Delegator

at_exit do
  Rack::Server.start app: Barbatos::App.new if Barbatos.invoke_by_appfile?
end
