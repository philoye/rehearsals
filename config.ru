require 'sinatra'
require "#{File.join(File.dirname(__FILE__),'lib','git-tags.rb')}"

# disable sinatra's auto-application starting
disable :run
 
# we're in dev mode
set :environment, :development

require File.join(File.dirname(__FILE__), 'rehearsals.rb')
map "/" do
  run Rehearsals::Application
end

require File.join(File.dirname(__FILE__), '../projectname.rb')
map "/head/" do
  Projectname::Application::set :public, File.join(File.expand_path(File.dirname(__FILE__)),'../public')
  Projectname::Application::set :views, File.join(File.expand_path(File.dirname(__FILE__)),'../views')
  Projectname::Application::set :site_root, '/head/'
  run Projectname::Application
end

eval <<-CODE
  module Master
    #{File.read("#{File.expand_path(File.dirname(__FILE__))}/lib/tags/master/projectname.rb")}
    Projectname::Application::set :public, File.join(File.expand_path(File.dirname(__FILE__)),'lib/tags/master/public')
    Projectname::Application::set :views, File.join(File.expand_path(File.dirname(__FILE__)),'lib/tags/master/views')
    Projectname::Application::set :site_root, '/master/'
  end
CODE
map "/master/" do
  run Master::Projectname::Application
end

tags = GitTags.export_tags
tags.each_with_index do |tag,index|
  safe_tag = tag['name'].gsub(/\s+/,'-').gsub(/[^\.A-Za-z0-9-]/,'')
  eval <<-CODE
    module Tag#{index}
      #{File.read("#{File.expand_path(File.dirname(__FILE__))}/lib/tags/#{tag['name']}/projectname.rb")}
      Projectname::Application::set :public, File.join(File.expand_path(File.dirname(__FILE__)),'lib/tags/#{tag['name']}/public')
      Projectname::Application::set :views, File.join(File.expand_path(File.dirname(__FILE__)),'lib/tags/#{tag['name']}/views')
      Projectname::Application::set :site_root, '/tags/#{safe_tag}/'
    end
  CODE
  map "/tags/#{safe_tag}/" do
    eval "run Tag#{index}::Projectname::Application"
  end
end