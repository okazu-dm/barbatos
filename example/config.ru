$LOAD_PATH.push('../lib/')
require 'barbatos'

class WebApp < Barbatos::App
  def initialize
    super
    @counter = 0
  end
  get '/' do
    @counter += 1
    render('sample.erb', count: @counter)
  end

  get '/e' do
    puts self
    response.write(request.pretty_inspect)
  end
end

run WebApp.instance
