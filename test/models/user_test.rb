require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

describe "User Model" do

  before do
    @users = []
  end

  it 'can construct a new instance' do
    user = User.new
    refute_nil user
  end

  it 'save succesfully' do
    user = get_mock_user
    user.id.wont_be_nil
  end

  it 'can create article' do
    user = get_mock_user
    article = user.add_article(mock_article)
    article.must_be_instance_of Article
    article.id.wont_be_nil
    article.user.must_equal user
  end

  it 'can remove article' do
    user = get_mock_user
    article = user.add_article(mock_article)
    user.remove_article(article).destroy
    user.articles.must_be_empty
    Article[article.id].must_be_nil
  end

  it 'remove all articles on delete' do
    user = get_mock_user
    30.times { |c| user.add_article(mock_article) }
    user.articles.count.must_equal 30
    user.destroy && sleep(2) # Give SQlite time to sync ;)
    Article.count(:user_id => user.id).must_equal 0
  end

  it '#from_github' do
    user = get_mock_user
    User.from_github(user).must_equal user
    gh_user = OpenStruct.new(:login => 'test01', :email => 'test@test.com',
                             :avatar_url => 'a')
    new_user = User.from_github(gh_user)
    new_user.login.must_equal gh_user.login
    new_user.email.must_equal gh_user.email
    new_user.avatar_url.must_equal gh_user.avatar_url

    gh_user_no_email = OpenStruct.new(:login => 'test02', :email => nil,
                                      :avatar_url => 'a')

    new_user = User.from_github(gh_user_no_email)
    new_user.login.must_equal gh_user_no_email.login
    new_user.email.must_equal 'nobody@nowhere.com'
    new_user.avatar_url.must_equal gh_user_no_email.avatar_url
  end

  after do
    remove_mock_users!
  end

end
