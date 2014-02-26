Kbase::App.controllers :article do

  layout :default

  get :new, :map => '/new' do
    render :new
  end

  get :show, :with => :id do
    @article = Article[params['id']]
    render :show
  end

  get :tag, :map => '/tag' do
    @articles = Tag[params[:id]].articles
    render :index
  end

  post :save, :map => '/save' do
    article = Article.new(params['article'])
    if article.valid?
      tags = params['tags'].split(',').map { |t| Tag.find_or_create(:name => t.strip) }
      article = current_user.add_article(article)
      tags.each { |t| article.add_tag(t) }
    end
    redirect url(:article, :show, :id => article.id)
  end

end
