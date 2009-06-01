require 'sinatra'
 
# disable sinatra's auto-application starting
disable :run
 
# we're in dev mode
set :environment, :development

require File.join(File.dirname(__FILE__), 'rehearsals.rb')
map "/" do
  run Rehearsals
end

require File.join(File.dirname(__FILE__), '../projectname.rb')
map "/latest/" do
  run Projectname
end

tags = []
Dir.foreach(File.join(File.dirname(__FILE__),"lib/tags")) do |item|
  unless ['.','..','.DS_Store'].include?(item)
    tags << item
  end
end

tags.each_with_index do |tag,index|
  safe_tag = tag.gsub(/\s+/,'-').gsub(/[^\.A-Za-z0-9-]/,'')
  eval <<-CODE
    class Tag#{index}
      #{File.read("#{File.expand_path(File.dirname(__FILE__))}/lib/tags/#{safe_tag}/projectname.rb")}
      Projectname::set :public, File.join(File.expand_path(File.dirname(__FILE__)),'lib/tags/#{safe_tag}/public')
      Projectname::set :views, File.join(File.expand_path(File.dirname(__FILE__)),'lib/tags/#{safe_tag}/views')
    end
  CODE
  map "/tags/#{tag}/" do
    eval "run Tag#{index}::Projectname"
  end
end


