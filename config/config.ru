__ROOT__ = File.expand_path(File.join(File.dirname(__FILE__),'../'))

require 'sinatra'
require File.join(__ROOT__,'lib','git_export.rb')

begin
  config = YAML.load(File.read("#{__ROOT__}/config/application.yml"))
  AppName = config['application_class_name']
  AppFile = config['application_file_name']
rescue => ex
  raise "Cannot read the application.yml file at #{__ROOT__}/config/application.yml - #{ex.message}"
end

# Serve up the version browsing app
require File.join(__ROOT__, 'rehearsals.rb')
map "/" do
  run Rehearsals::Application
end

# Read in all tagged versions, eval them, overwrite the public/views directories and serve them up.
tags = GitExport.export_tags
tags.each_with_index do |tag,index|
  safe_tag = tag['name'].gsub(/\s+/,'-').gsub(/[^\.A-Za-z0-9-]/,'')
  eval <<-CODE
    module Tag#{index}
      #{File.read("#{__ROOT__}/lib/tags/#{tag['name']}/#{AppFile}")}
      #{AppName}::Application::set :public, "#{__ROOT__}/lib/tags/#{tag['name']}/public"
      #{AppName}::Application::set :views, "#{__ROOT__}/lib/tags/#{tag['name']}/views"
      #{AppName}::Application::set :site_root, "/tags/#{safe_tag}/"
    end
  CODE
  map "/tags/#{safe_tag}/" do
    eval "run Tag#{index}::#{AppName}::Application"
  end
end

# We don't want to show head/master in production
if ENV['RACK_ENV'] == 'development'

  # Serve the curent version of the app (i.e., HEAD)
  require File.join(__ROOT__, '..',AppFile)
  map "/head/" do
    eval(AppName)::Application::set :public, File.join(__ROOT__,'../public')
    eval(AppName)::Application::set :views, File.join(__ROOT__,'../views')
    eval(AppName)::Application::set :site_root, '/head/'
    run eval(AppName)::Application
  end

  # Serve up the version of the app at Master
  eval <<-CODE
    module Master
      #{File.read("#{__ROOT__}/lib/tags/master/#{AppFile}")}
      #{AppName}::Application::set :public, "#{__ROOT__}/lib/tags/master/public"
      #{AppName}::Application::set :views, "#{__ROOT__}/lib/tags/master/views"
      #{AppName}::Application::set :site_root, '/master/'
    end
  CODE
  map "/master/" do
    eval "run Master::#{AppName}::Application"
  end

end
