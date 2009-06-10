namespace :tags do 
  require "#{File.join(File.dirname(__FILE__),'lib','git_export.rb')}"

  task :export do
    GitExport.export_tags
  end
  task :clobber do
    GitExport.clobber_export
  end
end