namespace :tags do 
  require "#{File.join(File.dirname(__FILE__),'lib','git-tags.rb')}"

  task :export do
    GitTags.export_tags
  end
  task :clobber do
    GitTags.clobber_export
  end
end