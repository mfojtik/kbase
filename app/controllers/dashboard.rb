Kbase::App.controllers :dashboard do

  include Kbase::AuthPlugins
  layout :default

  get :index, :map => '/' do
    @articles = Article.order(Sequel.desc(:updated_at)).all
    render 'article/index'
  end

end
