require 'sinatra/base'
require 'haml'

class Rehearsals < Sinatra::Base

  set :static, true
  set :public, File.join(File.expand_path(File.dirname(__FILE__)),'public')
  set :views, File.join(File.expand_path(File.dirname(__FILE__)),'views')

  get '/' do
    "We'll show  a list of versions here."
  end

end