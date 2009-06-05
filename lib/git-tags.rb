require 'rubygems'
require 'fileutils'

module GitTags

  def self.export_tags
    path_to_repo = File.join(File.expand_path('../..',File.dirname(__FILE__)))
    tags_dir = File.join(File.expand_path(File.dirname(__FILE__)),'tags')
    FileUtils.mkdir_p tags_dir
    export(tags_dir,path_to_repo)
    return tags
  end
  def self.tags
    tags = []
    text = `cd .. && git tag -n`
    lines = text.split("\n")
    lines.each do |line|
      h = {}
      t = line.split(/\s+/,2)
      h["name"] = t[0]
      h["message"] = t[1]
      tags << h
    end
    return tags
  end
  def self.export(tags_dir,path_to_repo)
    tags.each do |tag|
      unless File.directory? "#{tags_dir}/#{tag['name']}" 
        `git clone #{path_to_repo} #{tags_dir}/#{tag['name']}`
        Dir.chdir("#{tags_dir}/#{tag['name']}") do
          `git reset --hard #{tag['name']}`
        end
      end
    end
  end
  def self.clobber_export
    FileUtils.rm_rf File.join(File.expand_path(File.dirname(__FILE__)),'tags')
  end

end