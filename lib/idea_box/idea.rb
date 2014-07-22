require 'yaml'
require 'yaml/store'

class Idea
  include Comparable
  attr_reader :title, :description, :rank, :id

  def initialize(attributes = {})
    @title = attributes["title"]
    @description = attributes["description"]
    @rank = attributes["rank"] || 0
    @id = attributes["id"]
  end

  def like!
    @rank += 1
  end

  def <=>(other)
    other.rank <=> rank
  end
end
