require 'sinatra/base'
require 'haml'

class Projectname < Sinatra::Base

  set :static, true
  set :public, File.join(File.expand_path(File.dirname(__FILE__)),'public')
  set :views, File.join(File.expand_path(File.dirname(__FILE__)),'views')

  get '/' do
    haml :index
  end

end