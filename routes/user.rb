class App < Sinatra::Base
  get '/login' do
    redirect '/' if logged_in?

    erb :login
  end

  post '/login' do
    login params[:username], params[:password]
  end

  get '/logout' do
    logout
  end

  get '/signup' do
    redirect '/' if logged_in?

    erb :signup
  end

  post '/signup' do
    redirect '/signup' if params[:password] != params[:password2]

    @user = User.create({
        username: params[:username],
        password: params[:password]
      })
    if @user.saved? && @user.id
      flash[:notice] = "Account created."
      redirect '/'
    else
      flash[:error] = "There were some problems creating your account!"
      redirect '/signup'
    end
  end
end
