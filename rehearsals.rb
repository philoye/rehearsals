require 'sinatra/base'
require 'haml'

class Rehearsals < Sinatra::Base

  set :static, true
  set :public, File.join(File.expand_path(File.dirname(__FILE__)),'public')
  set :views, File.join(File.expand_path(File.dirname(__FILE__)),'views')

  require "#{File.join(File.dirname(__FILE__),'lib','git-export-tags.rb')}"
  
  get '/' do
    @tags = GitExportTags.new('../.git').tags
    haml :index 
  end

end