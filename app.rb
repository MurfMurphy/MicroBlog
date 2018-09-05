require 'sinatra'
require 'sinatra/activerecord'
require './models/user.rb'
require 'bundler/setup'
require 'sinatra/flash'

configure(:development){set :database, "sqlite3:micro_blog.sqlite3"}
enable :sessions

get '/' do
    @title= 'Home'
    
    if session[:user_id] == nil
        return redirect '/sign-in'
    elsif session[:user_id]
        @user = current_user
    end

    erb :home
end

get '/sign-in' do
    @title = 'Sign In'
    erb :sign_in

end

get '/sign-up' do
    @title = 'Sign Up'
    erb :sign_up
end

get '/sign-out' do 
    session[:user_id] == nil
    redirect '/'
end

post '/sign-up' do
    if params[:user][:password] != params[:password_confirm]
        flash[:failure] = "Passwords must match!"
        redirect '/sign-up'
        return
    end

    user = User.create(params[:user])

    session[:user_id] = user.id
    redirect '/'

end

post '/sign-in' do

    user = User.where(username: params[:user][:username]).first

    if user && user.username == params[:user][:username] && user.password == params[:user][:password]
        session[:user_id] = user.id
        
        return redirect '/'
    else
        flash[:failure] = "Incorrect Username or Password."
        redirect '/sign-in'
    end
end

def current_user
    if session[:user_id]
        User.find(session[:user_id])
    end
end

