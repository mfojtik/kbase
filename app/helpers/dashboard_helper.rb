# Helper methods defined here can be accessed in any controller or view in the application

Kbase::App.helpers do

  def random_string
    rand(36**8).to_s(36)
  end

  def tags
    Tag.all
  end

end
