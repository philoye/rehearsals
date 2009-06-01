require "#{File.join(File.dirname(__FILE__),'lib','git-export-tags.rb')}"

task :update_tags do
  puts "Removing all tag checkouts"
  puts "About to clone, checkout, and reset to tag."
  GitExportTags.new('../.git')
end
