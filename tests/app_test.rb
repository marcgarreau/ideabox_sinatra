require 'simplecov'
SimpleCov.start

require 'sinatra/base'
require 'minitest/autorun'
require 'minitest/pride'
require 'minitest/spec'
require 'rack/test'
require 'nokogiri'
require './lib/app.rb'
require './lib/idea_box.rb'

describe IdeaBoxApp do
  include Rack::Test::Methods

  def app
    IdeaBoxApp.new
  end

  it "reaches destinations" do
    get "/"
    assert last_response.ok?
  end
end
