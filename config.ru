require 'sinatra'
 
# disable sinatra's auto-application starting
disable :run
 
# we're in dev mode
set :environment, :development
 
map "/" do
  haml
end

require File.join(File.dirname(__FILE__), '../projectname.rb')
map "/latest/" do
  run Projectname
end

tags = ["1","2"] # In the real world, we'll use grit to get the tags or just inspect the items in the 'releases' directory that are cap'ed over.
tags.each do |tag|
  eval <<-CODE
    class Version#{tag}
      #{File.read("#{File.expand_path(File.dirname(__FILE__))}/tags/#{tag}/projectname.rb")}
      Projectname::set :public, File.join(File.expand_path(File.dirname(__FILE__)),'/tags/#{tag}/public')
      Projectname::set :views, File.join(File.expand_path(File.dirname(__FILE__)),'/tags/#{tag}/views')
    end
  CODE
  map "/v#{tag}/" do
    eval "run Version#{tag}::Projectname"
  end
end

