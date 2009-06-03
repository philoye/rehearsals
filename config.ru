require 'sinatra'
require "#{File.join(File.dirname(__FILE__),'lib','git-export-tags.rb')}"
 
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

tags = GitExportTags.new('../.git').tags
tags.each_with_index do |tag,index|
  eval <<-CODE
    class Tag#{index}
      #{File.read("#{File.expand_path(File.dirname(__FILE__))}/lib/tags/#{tag.name}/projectname.rb")}
      Projectname::set :public, File.join(File.expand_path(File.dirname(__FILE__)),'lib/tags/#{tag.name}/public')
      Projectname::set :views, File.join(File.expand_path(File.dirname(__FILE__)),'lib/tags/#{tag.name}/views')
    end
  CODE
  safe_tag = tag.name.gsub(/\s+/,'-').gsub(/[^\.A-Za-z0-9-]/,'')
  map "/tags/#{safe_tag}/" do
    eval "run Tag#{index}::Projectname"
  end
end


