require 'yaml'
require 'yaml/store'

class Idea
  include Comparable
  attr_reader :title, :description, :rank, :id
  attr_accessor :tags, :myfile

  def initialize(attributes = {})
    @title       = attributes["title"]
    @description = attributes["description"]
    @rank        = attributes["rank"] || 0
    @id          = attributes["id"]
    @tags        = [attributes["tags"]].flatten
    @myfile      = attributes["myfile"]
  end

  def to_h
    {
      "title"       => title,
      "description" => description,
      "rank"        => rank,
      "id"          => id,
      "tags"        => tags,
      "myfile"      => myfile
    }
  end

  def like!
    @rank += 1
  end

  def add_a_tag(data)
    @tags << data[:tags]
  end

  def add_upload(filename)
    @myfile = ""
    @myfile << filename
  end

  def <=>(other)
    other.rank <=> rank
  end
end
