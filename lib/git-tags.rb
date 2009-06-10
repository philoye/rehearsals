require 'rubygems'
require 'fileutils'

module GitTags

  @path_to_repo = File.join(File.expand_path('../..',File.dirname(__FILE__)))
  @tags_dir = File.join(File.expand_path(File.dirname(__FILE__)),'tags')

  def self.export_tags
    FileUtils.mkdir_p @tags_dir
    update_master
    update_tags
    return tags
  end
  def self.tags
    tags = []
    text = `cd #{@path_to_repo} && git tag -n`
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
  def self.update_master
    unless File.directory? "#{@tags_dir}/master"
      `git clone #{@path_to_repo} #{@tags_dir}/master`
    end
    Dir.chdir("#{@tags_dir}/master") do
      `git pull origin master --quiet`
      `git reset --hard master`
    end
  end
  def self.update_tags
    tags.each do |tag|
      unless File.directory? "#{@tags_dir}/#{tag['name']}" 
        `git clone #{@path_to_repo} #{@tags_dir}/#{tag['name']}`
        Dir.chdir("#{@tags_dir}/#{tag['name']}") do
          `git reset --hard #{tag['name']}`
        end
      end
    end
  end
  def self.clobber_export
    FileUtils.rm_rf File.join(File.expand_path(File.dirname(__FILE__)),'tags')
  end

end