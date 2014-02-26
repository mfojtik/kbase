# Helper methods defined here can be accessed in any controller or view in the application

Kbase::App.helpers do

  def github
    Kbase::AuthPlugins::Github
  end

  def current_user
    @current_user ||= User[session[:current_user_id]]
  end

end
