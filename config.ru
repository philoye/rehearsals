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
map "/latest/" do
  run Projectname::Application
end

tags = GitTags.export_tags
tags.each_with_index do |tag,index|
  eval <<-CODE
    module Tag#{index}
      #{File.read("#{File.expand_path(File.dirname(__FILE__))}/lib/tags/#{tag['name']}/projectname.rb")}
      Projectname::Application::set :public, File.join(File.expand_path(File.dirname(__FILE__)),'lib/tags/#{tag['name']}/public')
      Projectname::Application::set :views, File.join(File.expand_path(File.dirname(__FILE__)),'lib/tags/#{tag['name']}/views')
    end
  CODE
  safe_tag = tag['name'].gsub(/\s+/,'-').gsub(/[^\.A-Za-z0-9-]/,'')
  map "/tags/#{safe_tag}/" do
    eval "run Tag#{index}::Projectname::Application"
  end
end