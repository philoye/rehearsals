require 'rubygems'
require 'fileutils'
require 'grit'
include Grit

class GitExportTags
  
  def initialize(path_to_repo)
    @path_to_repo = path_to_repo
    @repo = Repo.new(path_to_repo)
    @tags_dir = File.join(File.expand_path(File.dirname(__FILE__)),'tags')
    
    self.clobber_tag_checkouts
    self.prepare_tag_directory
    self.checkout_tags
  end
  def tags
    @repo.tags
  end
  def prepare_tag_directory
    FileUtils.mkdir_p @tags_dir
  end
  def clobber_tag_checkouts
    FileUtils.rm_rf @tags_dir
  end
  def checkout_tags
    @repo.tags.each do |tag|
      `git clone #{@path_to_repo} #{@tags_dir}/#{tag.name}`
      Dir.chdir("#{@tags_dir}/#{tag.name}") do
        `git reset --hard #{tag.name}`
      end
    end  
  end

end