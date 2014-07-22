require 'idea_box'
require 'sinatra'
require 'sinatra/reloader'
require 'sass'

class IdeaBoxApp < Sinatra::Base
  get('/styles.css'){ scss :styles }
  set :method_override, true
  set :root, 'lib/app'

  configure :development do
    register Sinatra::Reloader
  end

  get '/:id/edit' do |id|
    idea = IdeaStore.find(id.to_i)
    erb :edit, locals: {idea: idea}
  end

  get '/' do
    erb :index, locals: {ideas: IdeaStore.all, idea: Idea.new(params)}
  end

  put '/:id' do |id|
    IdeaStore.update(id.to_i, params[:idea])
    redirect '/'
  end

  post '/:id/like' do |id|
    idea = IdeaStore.find(id.to_i)
    idea.like!
    IdeaStore.update(id.to_i, idea.to_h)
    redirect '/'
  end

  post '/' do
    IdeaStore.create(params[:idea])
    redirect '/'
  end

  delete '/:id' do |id|
    IdeaStore.delete(id.to_i)
    redirect '/'
  end

  not_found do
    erb :error
  end

  run! if app_file == $0
end
