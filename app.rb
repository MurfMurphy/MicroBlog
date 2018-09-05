require 'sinatra'
require 'sinatra/activerecord'
require './models/user.rb'
require 'bundler/setup'
require 'sinatra/flash'

configure(:development){set :database, "sqlite3:micro_blog.sqlite3"}
enable :sessions

get '/' do
    @title= 'Home'
    erb :home, layout: :layout
    if session[:user_id] == nil
        redirect '/sign-in'
    elsif session[:user_id]
        @user = current_user
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

def current_user
    if session[:user_id]
        User.find(session[:user_id])
    end
end


# post '/sign-in' do
#     user = User.where(email: params[:email]).first

#     if user && user.password == params[:password]
#         session[:user_id] = user.id
        
#         redirect '/'
#     else
#         redirect '/sign-in'
#         flash[:failure] = "Incorrect Username or Password."
#     end
# end