require 'sinatra'
require 'sinatra/activerecord'
require './models/user.rb'
require 'bundler/setup'
require 'sinatra/flash'

set :database, "sqlite3:micro_blog.sqlite3"
enable :sessions

get '/' do
    @title= 'Home'
    erb :home, layout: :layout
    if session[:user_id] == nil
        redirect '/sign-in'
    end
end

get '/sign-in' do
    @title = 'Sign In'
    erb :sign_in, layout: :layout

end

get '/sign-up' do
    @title = 'Sign Up'
    erb :sign_up, layout: :layout
end

get '/sign-out' do 
    session[:user_id] == nil
    redirect '/'
end

get '/logged_in' do
    puts "session: "
    puts session.inspect
    if session[:user_id]
        @user = current_user
        "logged in page!"
    else
        redirect '/'
    end
end

post '/sign-in' do
    user = User.where(email: params[:email]).first

    if user && user.password == params[:password]
        session[:user_id] = user.id
        
        redirect '/logged_in'
    else
        redirect '/sign-in'
        flash[:failure] = "Incorrect Username or Password."
    end
end

def current_user
    if session[:user_id]
        User.find(session[:user_id])
    end
end