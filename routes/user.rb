class App < Sinatra::Base

  get '/login' do
    redirect '/' if logged_in?

    erb :'website/login', layout: :"layouts/default"
  end

  post '/login' do
    login params[:username], params[:password]
  end

  get '/logout' do
    logout
  end

  get '/signup' do
    redirect '/' if logged_in?

    erb :'website/signup', layout: :"layouts/default"
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

  get '/connect' do
    restricred_area

    @user = current_user
    @header = "Connections"
    query = {:id.not => @user.id ,:connections => [:target => @user]}
    @requests = User.all(query) - @user.contacts
    erb :'messenger/search', layout: :"layouts/messenger"
  end

  get '/connect/:id' do
    restricred_area

    if user = User.get(params[:id])
      current_user.send_request user
    end

    redirect '/connect'
  end

  post '/connect/find' do
    restricred_area

    @user = current_user
    @header = "Connections"
    query = { :fields => [:id, :username],
              :id.not => @user.id,
              :username.like => "%#{params[:search]}%",
            }

    User.all(query).to_json only: [:id, :username]
  end

end
