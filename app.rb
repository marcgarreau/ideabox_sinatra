require './idea'

class IdeaBoxApp < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  not_found do
    erb :error
  end

  get '/' do
    erb :index
  end

  post '/' do
    idea = Idea.new
    idea.save
    "Creating an IDEA!"
  end

  run! if app_file == $0
end
