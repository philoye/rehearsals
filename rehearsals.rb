require 'sinatra/base'
require 'haml'
require "#{File.join(File.dirname(__FILE__),'lib','git_export.rb')}"

module Rehearsals
  class Application < Sinatra::Base

    set :static, true
    set :public, File.join(File.expand_path(File.dirname(__FILE__)),'public')
    set :views, File.join(File.expand_path(File.dirname(__FILE__)),'views')

    get '/' do
      @tags = GitExport.tags
      @environment = ENV['RACK_ENV']
      haml :index 
    end

  end
end