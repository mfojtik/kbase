Kbase::App.controllers :article do

  layout :default

  get :new, :map => '/new' do
    @article = Article.new
    render :new
  end

  get :edit, :with => :id do
    halt(401) unless current_user
    @article = Article[params['id']]
    render :new
  end

  get :show, :with => :id do
    redirect "/#{Article[params['id']].to_permalink}"
  end

  get %r{/(\d+)\-.*} do
    @article = Article[params[:captures].first]
    @article ? render(:show) : pass
  end

  get %r{/tag/([a-zA-Z0-9_]+)$} do
    if tag = Tag.where(:name => params[:captures].first).first
      @articles = tag.articles_dataset.order(Sequel.desc(:updated_at)).all
      render :index
    else
      not_found
    end
  end

  get :destroy, :with => :id do
    article = current_user.articles_dataset.first(id: params[:id])
    if article
      article.destroy
      flash[:notice] = 'Article was succesfully deleted.'
      redirect url(:dashboard, :index)
    else
      not_found
    end
  end

  get :tag, :map => '/tag' do
    tag = Tag[params['id']]
    redirect "/tag/#{tag.name}"
  end

  post :save, :map => '/save' do
    halt(401) unless current_user
    @article = Article.new(params['article'])
    if !@article.valid?
      flash[:notice] = "Unable to save article with data provided."
      render :new
    else
      if params['action'] == 'update'
        @article = Article[params['id']]
        @article.edited_by = current_user.id
        @article.update_fields(params['article'], [:title, :body])
      else
        @article = current_user.add_article(@article)
      end
      @article.update_tags(article_tags)
    end

    flash[:notice] = "Article saved. #{article_link('Share', @article)}"
    redirect url(:article, :show, :id => @article.id)
  end

end
