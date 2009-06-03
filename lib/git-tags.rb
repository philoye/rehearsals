require 'rubygems'
require 'fileutils'
require 'grit'
include Grit

class GitTags

  attr_reader :tags_dir,
              :path_to_repo,
              :repo

  def initialize(path_to_repo)
    @tags_dir = File.join(File.expand_path(File.dirname(__FILE__)),'tags')
    FileUtils.mkdir_p @tags_dir

    @path_to_repo = path_to_repo
    @repo = Repo.new(path_to_repo)
    
    # self.checkout_tags
  end
  def tags
    @repo.tags
  end
  def clobber_export
    FileUtils.rm_rf @tags_dir
  end
  def export
    @repo.tags.each do |tag|
      unless File.directory? "#{@tags_dir}/#{tag.name}" 
        `git clone #{@path_to_repo} #{@tags_dir}/#{tag.name}`
        Dir.chdir("#{@tags_dir}/#{tag.name}") do
          `git reset --hard #{tag.name}`
        end
      end
    end  
    return @repo
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