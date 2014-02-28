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

  it '#author' do
    article = @user.add_article(mock_article)
    article.author.must_equal @user
    new_user = get_mock_user
    article.update(:edited_by => new_user.id, :body => 'test')
    article.author.must_equal new_user
  end

  it '#to_html' do
    article = @user.add_article(mock_article)
    article.update(:body => '**test**')
    article.to_html.must_equal "<p><strong>test</strong></p>\n"
    article.html_body.must_equal "<p><strong>test</strong></p>\n"
  end

  it '#to_permalink' do
    article = @user.add_article(mock_article)
    article.update(:title => 'test article')
    article.to_permalink.must_equal "#{article.id}-test-article"
  end

  it '#tags_values' do
    article = @user.add_article(mock_article)
    article.add_tag(Tag.create(:name => 'mock'))
    article.add_tag(Tag.create(:name => 'test'))
    article.add_tag(Tag.create(:name => 'foo'))
    article.tags_value.must_equal 'mock,test,foo'
  end

  it '#update_tags' do
    article = @user.add_article(mock_article)
    article.add_tag(@tags[0])
    article.add_tag(@tags[1])
    article.add_tag(@tags[2])
    article.update_tags([@tags[0], @tags[3]])
    article.tags.must_include @tags[0]
    article.tags.must_include @tags[3]
    article.tags.wont_include @tags[1]
  end

  after do
    remove_mock_users!
    remove_tags!
  end

end
