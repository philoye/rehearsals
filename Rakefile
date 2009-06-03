namespace :tags do 
  require "#{File.join(File.dirname(__FILE__),'lib','git-tags.rb')}"

  task :export do
    GitTags.new('../.git').export
  end
  task :clobber do
    GitTags.new('../.git').clobber_export
  end
end