require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

describe "Article Model" do

  before do
    @users = []
    @tags = generate_random_tags
    @user = get_mock_user
  end

  it 'can associate a single tag' do
    article = @user.add_article(mock_article)
    article_tag = @tags.first
    article.add_tag(article_tag).inspect
    article.tags.must_include article_tag
  end

  it 'can associate multiple tags' do
    article = @user.add_article(mock_article)
    @tags.each { |t| article.add_tag(t) }
    article.tags.count.must_equal 30
  end

  it 'disassociate tags on destroy' do
    article = @user.add_article(mock_article)
    @tags.each { |t| article.add_tag(t) }
    article.destroy
    ArticleTags.where(:article_id => article.id).count.must_equal 0
  end

  it 'validates attributes' do
    Article.new.valid?.must_equal false
    Article.new(:title => '').valid?.must_equal false
    Article.new(:title => 'aaa').valid?.must_equal false
    Article.new(:title => 'aaa', :body => 'bbb').valid?.must_equal true
  end

  it 'summarize the body' do
    big_text = Faker::Lorem.paragraphs(10).join("\n")
    small_text = Faker::Lorem.sentence
    article = @user.add_article(:title => 'Test Article', :body => big_text)
    article.summary.wont_be_nil
    (article.summary.size < big_text.size).must_equal true
    article = @user.add_article(:title => 'Second Test Article', :body => small_text)
    article.summary.wont_be_nil
    article.summary.must_equal small_text
  end

  after do
    remove_mock_users!
    remove_tags!
  end

end
