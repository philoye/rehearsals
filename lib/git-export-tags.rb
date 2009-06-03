require 'rubygems'
require 'fileutils'
require 'grit'
include Grit

class GitExportTags

  attr_reader :tags_dir,
              :path_to_repo,
              :repo


  def initialize(path_to_repo)
    @tags_dir = File.join(File.expand_path(File.dirname(__FILE__)),'tags')
    FileUtils.mkdir_p @tags_dir

    @path_to_repo = path_to_repo
    @repo = Repo.new(path_to_repo)
    
    self.checkout_tags
  end
  def tags
    @repo.tags
  end
  def clobber_tag_checkouts
    FileUtils.rm_rf @tags_dir
  end
  def checkout_tags
    @repo.tags.each do |tag|
      unless File.directory? "#{@tags_dir}/#{tag.name}" 
        `git clone #{@path_to_repo} #{@tags_dir}/#{tag.name}`
        Dir.chdir("#{@tags_dir}/#{tag.name}") do
          `git reset --hard #{tag.name}`
        end
      end
    end  
  end
  def tags_from_dir
    tags = []
    Dir.foreach(File.join(File.dirname(__FILE__),'tags')) do |item|
      unless ['.','..','.DS_Store'].include?(item)
        tags << item
      end
    end
    return tags
  end

end