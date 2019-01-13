require 'sinatra'
require 'sinatra/base'
require 'sinatra/activerecord'
require './lib/user'

set :database_file, 'config/database.yml'

class Warble < Sinatra::Base

  register Sinatra::ActiveRecordExtension
  set :sessions, true

  get '/' do
    erb :index
  end

  post '/signin' do
    p params[:sign_in_username]
    p params[:sign_in_password]
    p user = User.authenticate(params[:sign_in_username], params[:sign_in_password])
    if user
      session[:id] = user.id
      redirect "/private_profile/#{session[:id]}"
    else
      redirect '/'
    end
  end

  post '/signup' do
    user = User.create(
      username: params[:sign_up_username],
      email: params[:sign_up_email],
      password: params[:sign_up_password]
    )

    if user
      session[:id] = user.id
      redirect "/private_profile/#{session[:id]}"
    else
      redirect '/'
    end

  end

  get '/private_profile/:id' do
    if signed_in?
      @user = User.find(params[:id])
      erb :private_profile
    else
      redirect '/'
    end
  end

  private

  def signed_in?
    !current_user.nil?
  end

  def current_user
    @current_user ||= User.find(session[:id])
  end

  run! if app_file == $0

end
