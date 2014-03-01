module Kbase
  module AuthPlugins
    module Github

      GITHUB_API       = 'https://api.github.com'
      GITHUB_AUTH      = 'https://github.com'

      GITHUB_CLIENT_ID = ENV['GITHUB_CLIENT_ID']
      GITHUB_SECRET_ID = ENV['GITHUB_SECRET_ID']

      class User < OpenStruct; end

      def self.login_url(token, scope='user:email')
        "#{GITHUB_AUTH}/login/oauth/authorize?"+
          "client_id=#{GITHUB_CLIENT_ID}&state=#{token}&scope=#{scope}"
      end

      def self.access_token_from_code(oauth_code)
        response = github_oauth.post do |r|
          r.url '/login/oauth/access_token'
          r.params['client_id'] = GITHUB_CLIENT_ID
          r.params['client_secret'] = GITHUB_SECRET_ID
          r.params['code'] = oauth_code
        end
        JSON::parse(response.body)['access_token']
      end

      def self.user(access_token)
        response = github.get do |r|
          r.url '/user'
          r.params['access_token'] = access_token
        end
        User.new(JSON::parse(response.body))
      end

      private

      def self.connection(url)
        Faraday.new(:url => url) do |client|
          client.request  :url_encoded
          client.headers['Accept'] = 'application/json'
          client.adapter  Faraday.default_adapter
          client.response :logger
        end
      end

      def self.github; @gh ||= connection(GITHUB_API); end
      def self.github_oauth; @gh_auth ||= connection(GITHUB_AUTH); end

    end
  end
end
