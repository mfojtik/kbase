# Helper methods defined here can be accessed in any controller or view in the application

Kbase::App.helpers do

  def github
    Kbase::AuthPlugins::Github
  end

  def current_user
    @current_user ||= User[session[:current_user_id]]
  end

  def login_url
    github.login_url(random_string)
  end

  def logout_url
    url(:authentication, :logout)
  end

  def github_callback_url
    absolute_url(:authentication, :authenticate)
  end

  def github_profile_url
    return unless current_user
    "https://github.com/%s" % current_user.login
  end

end
