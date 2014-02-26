class User < Sequel::Model

  one_to_many :articles

  plugin :association_dependencies
  add_association_dependencies :articles => :destroy

  plugin :validation_helpers

  def validate
    super
    validates_presence :login
    validates_length_range 1..149, :login
  end

  def self.from_github(user)
    first(:login => user.login) || create(:login => user.login, :email => user.email, :avatar_url => user.avatar_url)
  end

end
