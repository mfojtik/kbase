source 'https://rubygems.org'

# Distribute your app as a gem
# gemspec

# Server requirements
# gem 'thin' # or mongrel
# gem 'trinidad', :platform => 'jruby'

# Optional JSON codec (faster performance)
# gem 'oj'

# Project requirements
gem 'rake'

# Component requirements
gem 'haml'
gem 'sequel'
gem 'faraday'
gem 'json'
gem 'summarize'
gem 'github-markdown'

group :development do
  # Test requirements
  gem 'minitest', '~>2.6.0', :require => 'minitest/autorun', :group => 'test'
  gem 'rack-test', :require => 'rack/test', :group => 'test'
  gem 'faker'
  # Development database
  gem 'sqlite3'
  gem 'mysql2'
  # Development server
end

# Padrino Stable Gem
gem 'padrino', '0.12.0'

# Or Padrino Edge
# gem 'padrino', :github => 'padrino/padrino-framework'

# Or Individual Gems
# %w(core gen helpers cache mailer admin).each do |g|
#   gem 'padrino-' + g, '0.12.0'
# end
