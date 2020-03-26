require_relative '../../config/environment'

class ApplicationController < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  set :views, Proc.new { File.join(root, "../views/") }

  configure do
    enable :sessions
    set :session_secret, "secret"
  end

  get '/' do
    erb :home
  end

  get '/registrations/signup' do
    erb :'/registrations/signup'
  end

  post '/registrations' do
    #Gets the new user's name, email, and password from the params hash. Uses that info to create and save a new instance of User.
    @user = User.new(name: params["name"], email: params["email"], password: params["password"])
    @user.save
    session[:user_id] = @user.id #Signs the user in once they have completed the sign-up process.

    redirect '/users/home' #Redirect the user somewhere else, such as their personal homepage.  
  end

  get '/sessions/login' do
    #The line of code below render the view page in app/views/sessions/login.erb (login form)
    erb :'sessions/login'
  end

  post '/sessions' do
    #Is responsible for receiving the POST request that gets sent when a user hits 'submit' on the login form. This route contains code that grabs the user's info from the params hash, looks to match that info against the existing entries in the user database, and, if a matching entry is found, signs the user in.
    @user = User.find_by(email: params[:email], password: params[:password])
    if @user
      session[:user_id] = @user.id
      redirect '/users/home'
    end
    redirect '/sessions/login'
  end

  get '/sessions/logout' do
    session.clear
    redirect '/'
  end

  get '/users/home' do
    @user = User.find(session[:user_id])
    erb :'/users/home'
  end
end
