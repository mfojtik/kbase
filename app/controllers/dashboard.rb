Kbase::App.controllers :dashboard do

  include Kbase::AuthPlugins
  layout :default

  get :index, :map => '/' do
    @articles = Article.all
    render 'article/index'
  end

end
