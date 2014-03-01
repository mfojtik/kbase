Kbase::App.controllers :article do

  layout :default

  before :new, :edit, :save, :destroy do
    require_login!
  end

  get :new, :map => '/new' do
    @article = Article.new
    render :new
  end

  get :edit, :with => :id do
    @article = Article[params['id']]
    article_must_exist!
    render :new
  end

  get :show, :map => %r{/(\d+)\-.*} do
    @article = Article[params[:captures].first]
    article_must_exist!
    render :show
  end

  get :tags, :map => %r{/tag/([a-zA-Z0-9_]+)$} do
    tag_name = params[:captures].first.strip
    if tag = Tag.first(:name => tag_name)
      @articles = tag.ordered_articles
      render :index
    else
      error "Unknown tag <b>#{tag_name}</b>"
    end
  end

  get :destroy, :with => :id do
    article = current_user.articles_dataset.first(id: params[:id])
    if article
      article.destroy
      flash[:notice] = 'Article was succesfully deleted.'
      redirect dashboard_url
    else
      not_found
    end
  end

  get :tag, :map => '/tag' do
    tag = Tag[params['id']]
    redirect "/tag/#{tag.name}"
  end

  post :save, :map => '/save' do
    @article = Article.new(params['article'])
    if !@article.valid?
      article_is_invalid
      render :new
    else
      if is_update?
        @article = Article[params['id']]
        article_must_exist!
        @article.edited_by = current_user.id
        unless @article.update_fields(params['article'], [:title, :body])
          article_is_invalid
        end
      else
        @article = current_user.add_article(@article)
      end
      @article.update_tags(article_tags)
    end

    flash[:notice] = "Article saved. #{article_link('Share', @article)}"
    redirect article_url
  end

end
