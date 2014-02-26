Kbase::App.controllers :authentication do

  get :authenticate, :map => '/auth' do
    access_token = github.access_token_from_code(params['code'])
    github_user = github.user(access_token)
    session[:current_user_id] = User.from_github(github_user).id
    redirect url(:dashboard, :index)
  end

  get :logout, :map => '/logout' do
    session.delete(:current_user_id)
    redirect url(:dashboard, :index)
  end

end
