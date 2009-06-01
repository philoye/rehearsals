require 'rubygems'
require 'grit'
include Grit

root  = File.dirname(__FILE__)
# tag_path = File.expand_path(File.join(root, "../tags"))
repo_path = File.join(root, '../../.git')
repo = Repo.new(repo_path)


repo.tags.each do |tag|
  puts repo.tags.name
  puts repo.tags.message
  `cd #{tag_dir}`
  `git clone #{repo_path} #{tag}`
  Dir.chdir(tag) do
    `git reset --hard #{tag}`
  end
end  
