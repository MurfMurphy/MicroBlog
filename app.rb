require 'sinatra'
require 'sinatra/activerecord'
require './models/user.rb'
require './models/post.rb'
require 'bundler/setup'
require 'sinatra/flash'
require 'date'

configure(:development){set :database, "sqlite3:micro_blog.sqlite3"}
enable :sessions

get '/' do
    @title= 'Home'
    
    if session[:user_id] == nil
        return redirect '/sign-in'
        #If a users session id is nonexistant, it will redirect them to the sign-in page
    elsif session[:user_id]
        @user = current_user
        #If a user has a session id, it just links them to the current user.
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

post '/sign-out' do 
    session[:user_id] = nil
    redirect '/'
end

post '/sign-up' do
    if params[:user][:password] != params[:password_confirm]
        flash[:failure] = "Passwords must match!"
        return redirect '/sign-up'
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

post '/' do
    user=current_user

    post = Post.create(user_id: user.id, body: params[:posts][:body], posted_at: Time.now.strftime("%d/%m/%Y %H:%M"))

    redirect '/'

end

get '/profile' do
    user = current_user
    "Test WELCOME #{user.username}"
end

def current_user
    if session[:user_id]
        User.find(session[:user_id])
    end
end

