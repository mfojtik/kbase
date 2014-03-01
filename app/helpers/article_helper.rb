# Helper methods defined here can be accessed in any controller or view in the application

Kbase::App.helpers do

  def tag_url(tag_name)
    url("/tag/%s" % tag_name)
  end

  def article_url(article=nil)
    article ||= @article
    url("/%s" % article.to_permalink)
  end

  def article_link(text, article)
    link_to text, url("/%s" % article.to_permalink)
  end

  def article_tags
    params['tags'].split(',').map { |t|
      Tag.find_or_create(:name => t.strip)
    }.compact
  end

  def require_login!
    unless current_user
      error "Please <a href='#{login_url}'>login</a> first to complete this action."
    end
  end

  def article_must_exist!
    unless @article
      error "Requested article does not exists (<b>#{request.path}</b>)"
    end
  end

  def is_update?
    params['action'] && params['action'] == 'update'
  end

  def article_is_invalid
    error "Sorry, but I cannot save the article like this."
  end
end
