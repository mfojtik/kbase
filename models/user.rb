class User < Sequel::Model

  one_to_many :articles

  plugin :timestamps, :create=>:created_at, :update=>:updated_at, :update_on_create=>true

  plugin :association_dependencies
  add_association_dependencies :articles => :destroy

  plugin :validation_helpers

  def validate
    super
    validates_presence :login
    validates_length_range 1..149, :login
  end

  def self.from_github(user)
    first(:login => user.login) || create(:login => user.login, :email => user.email || 'nobody@nowhere.com', :avatar_url => user.avatar_url)
  end

end
