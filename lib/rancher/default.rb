require 'rancher/middleware/follow_redirects'
require 'rancher/response/raise_error'
require 'rancher/version'

module Rancher

  # Default configuration options for {Client}
  module Default

    # Default API endpoint
    API_ENDPOINT = 'http://localhost:8080/v1/projects/1a5'.freeze

    # Default User Agent header string
    USER_AGENT   = "Rancher Ruby Gem #{Rancher::VERSION}".freeze

    # Default media type
    MEDIA_TYPE   = 'application/json'.freeze

    # In Faraday 0.9, Faraday::Builder was renamed to Faraday::RackBuilder
    RACK_BUILDER_CLASS = defined?(Faraday::RackBuilder) ? Faraday::RackBuilder : Faraday::Builder

    # Default Faraday middleware stack
    MIDDLEWARE = RACK_BUILDER_CLASS.new do |builder|
      builder.use Rancher::Middleware::FollowRedirects
      builder.use Rancher::Response::RaiseError
      builder.adapter Faraday.default_adapter
    end

    class << self

      # Configuration options
      # @return [Hash]
      def options
        Hash[Rancher::Configurable.keys.map{|key| [key, send(key)]}]
      end

      # Default API endpoint from ENV or {API_ENDPOINT}
      # @return [String]
      def api_endpoint
        ENV['RANCHER_API_ENDPOINT'] || API_ENDPOINT
      end

      # Default pagination preference from ENV
      # @return [String]
      def auto_paginate
        ENV['RANCHER_AUTO_PAGINATE']
      end

      # Default OAuth app key from ENV
      # @return [String]
      def access_key
        ENV['RANCHER_CLIENT_ID']
      end

      # Default OAuth app secret from ENV
      # @return [String]
      def secret_key
        ENV['RANCHER_SECRET']
      end

      # Default options for Faraday::Connection
      # @return [Hash]
      def connection_options
        {
          :headers => {
            :accept => default_media_type,
            :user_agent => user_agent
          }
        }
      end

      # Default media type from ENV or {MEDIA_TYPE}
      # @return [String]
      def default_media_type
        ENV['RANCHER_DEFAULT_MEDIA_TYPE'] || MEDIA_TYPE
      end

      # Default middleware stack for Faraday::Connection
      # from {MIDDLEWARE}
      # @return [String]
      def middleware
        MIDDLEWARE
      end

      # Default pagination page size from ENV
      # @return [Fixnum] Page size
      def per_page
        page_size = ENV['RANCHER_PER_PAGE']

        page_size.to_i if page_size
      end

      # Default proxy server URI for Faraday connection from ENV
      # @return [String]
      def proxy
        ENV['RANCHER_PROXY']
      end

      # Default User-Agent header string from ENV or {USER_AGENT}
      # @return [String]
      def user_agent
        ENV['RANCHER_USER_AGENT'] || USER_AGENT
      end

      # Default web endpoint from ENV or {WEB_ENDPOINT}
      # @return [String]
      def web_endpoint
        ENV['RANCHER_WEB_ENDPOINT'] || WEB_ENDPOINT
      end
    end
  end
end
