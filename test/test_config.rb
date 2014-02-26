RACK_ENV = 'test' unless defined?(RACK_ENV)
require File.expand_path('../../config/boot', __FILE__)
require 'faker'

def produce_random(klass, source, source_method, attr_name=:name, attrs={})
  retry_count = 0
  begin
    value = source.send(source_method)
    fail unless klass.where(attr_name => value).first.nil?
    klass.create({attr_name => value}.merge(attrs))
  rescue => e
    retry_count+=1
    if retry_count > 10
      puts "[ERETRY]: #{e.class}: #{e.message}"
      puts e.backtrace.join("\n")
      exit(1)
    else
      retry
    end
  end
end

def get_mock_user
  @users << (user = produce_random User, Faker::Name, 'first_name', :login, { :email => 'mock@user.com' })
  return user
end

def generate_random_tags
  tags = []
  30.times { tags << produce_random(Tag, Faker::Lorem, 'word') }
  tags
end

def remove_mock_users!
  @users.each { |u| u.destroy unless User[u.id].nil? }
  @users = []
end

def remove_tags!
  Tag.all { |t| t.destroy }
end

def mock_article
  { :title => Faker::Lorem.sentence, :body => Faker::Lorem.paragraph }
end

class MiniTest::Unit::TestCase
  include Rack::Test::Methods

  # You can use this method to custom specify a Rack app
  # you want rack-test to invoke:
  #
  #   app Kbase::App
  #   app Kbase::App.tap { |a| }
  #   app(Kbase::App) do
  #     set :foo, :bar
  #   end
  #
  def app(app = nil, &blk)
    @app ||= block_given? ? app.instance_eval(&blk) : app
    @app ||= Padrino.application
  end
end
