require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

describe "Tag Model" do

  before do
    @users = []
    @tags = generate_random_tags
    @user = get_mock_user
    @article = @user.add_article(mock_article)
    @article_second = @user.add_article(mock_article)
  end

  it 'list article associated with tag' do
    tag = @tags.first
    @article.add_tag(tag)
    tag.articles.wont_be_empty
    tag.articles.count.must_equal 1
    tag.articles.first.must_equal @article
  end

  it 'allow removing article from tag' do
    tag = @tags.last
    @article_second.add_tag(tag)
    tag.remove_article(@article_second)
    tag.articles.must_be_empty
    Article[@article_second.id].wont_be_nil
    @article_second.tags.wont_include tag
  end

  it 'validate name properly' do
    Tag.new.valid?.must_equal false
    Tag.new(:name => '').valid?.must_equal false
    Tag.new(:name => ' test').valid?.must_equal false
    Tag.new(:name => 'a-b').valid?.must_equal false
    Tag.new(:name => '?').valid?.must_equal false
    Tag.new(:name => @tags.first.name).valid?.must_equal false
    Tag.new(:name => 'valid_name').valid?.must_equal true
  end

  after do
    remove_mock_users!
    remove_tags!
  end

end
