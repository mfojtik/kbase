# Helper methods defined here can be accessed in any controller or view in the application

Kbase::App.helpers do

  def tag_url(tag_name)
    url("/tag/%s" % tag_name)
  end

  def article_url(article)
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

end
