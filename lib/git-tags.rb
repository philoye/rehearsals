require 'rubygems'
require 'fileutils'

class GitTags

  attr_reader :tags_dir,
              :path_to_repo,
              :repo

  def initialize(path_to_repo)
    @path_to_repo = path_to_repo
    @tags_dir = File.join(File.expand_path(File.dirname(__FILE__)),'tags')
    FileUtils.mkdir_p @tags_dir
  end
  def tags
    tagArray = []
    text = `cd .. && git tag -n`
    lines = text.split("\n")
    lines.each do |line|
      h = {}
      t = line.split(/\s+/,2)
      h["name"] = t[0].to_s
      h["message"] = t[1].to_s
      tagArray << h
    end
    return tagArray
  end
  def clobber_export
    FileUtils.rm_rf @tags_dir
  end
  def export
    tags.each do |tag|
      unless File.directory? "#{@tags_dir}/#{tag['name']}" 
        `git clone #{@path_to_repo} #{@tags_dir}/#{tag['name']}`
        Dir.chdir("#{@tags_dir}/#{tag['name']}") do
          `git reset --hard #{tag['name']}`
        end
      end
    end
  end
  def read_tags_from_dir
    tags = []
    Dir.foreach(@tags_dir) do |item|
      unless ['.','..','.DS_Store'].include?(item)
        tags << item
      end
    end
    return tags
  end

end