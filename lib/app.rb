require 'pry'
require 'idea_box'
require 'sinatra'
require 'sinatra/reloader'
require 'sass'

class IdeaBoxApp < Sinatra::Base
  set :root, 'lib/app'
  get('/styles.css'){ scss :styles }
  set :method_override, true
  set :public_folder, 'public'

  configure :development do
    register Sinatra::Reloader
  end

  configure do
    enable :sessions
    set :username, 'marc'
    set :password, 'omg'
  end

  get '/login' do
    erb :login
  end

  get '/:id/edit' do |id|
    idea = IdeaStore.find(id.to_i)
    erb :edit, locals: {idea: idea}
  end

  get '/filter' do
    erb :index, locals: {
        ideas: IdeaStore.all.select {|idea| idea.tags.include? params[:selected_tag]},
        idea: Idea.new(params),
        tags: IdeaStore.all.flat_map {|idea| idea.tags}.uniq.sort
      }
  end

  get '/' do
    erb :index, locals: {
        ideas: IdeaStore.all.sort,
        idea: Idea.new(params),
        tags: IdeaStore.all.flat_map {|idea| idea.tags}.uniq.sort
      }
  end

  put '/:id' do |id|
    IdeaStore.update(id.to_i, params[:idea])
    redirect '/'
  end

  post '/login' do
    if params[:username] == settings.username && params[:password] == settings.password
      session[:admin] = true
      redirect to('/')
    else
      erb :login
    end
  end

  post '/:id/like' do |id|
    idea = IdeaStore.find(id.to_i)
    idea.like!
    IdeaStore.update(id.to_i, idea.to_h)
    redirect '/'
  end

  post '/:id/add_tag' do |id|
    idea = IdeaStore.find(id.to_i)
    idea.add_a_tag(params[:idea])
    IdeaStore.update(id.to_i, idea.to_h)
    redirect '/'
  end

  post '/:id/upload' do |id|
    File.open('public/images/' + params['myfile'][:filename], "w") do |f|
      f.write(params['myfile'][:tempfile].read)
    end
    idea = IdeaStore.find(id.to_i)
    idea.add_upload(params[:myfile][:filename])
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
