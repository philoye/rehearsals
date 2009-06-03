require 'sinatra/base'
require 'haml'

class Rehearsals < Sinatra::Base

  set :static, true
  set :public, File.join(File.expand_path(File.dirname(__FILE__)),'public')
  set :views, File.join(File.expand_path(File.dirname(__FILE__)),'views')

  require "#{File.join(File.dirname(__FILE__),'lib','git-tags.rb')}"
  
  get '/' do
    @tags = GitTags.new('../.git').export.tags
    haml :index 
  end

end