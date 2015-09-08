module Rancher
  # Configuration options for {Client}, defaulting to values
  # in {Default}
  module Configurable
    # @!attribute api_endpoint
    #   @return [String] Base URL for API requests. default: https://api.github.com/
    # @!attribute auto_paginate
    #   @return [Boolean] Auto fetch next page of results until rate limit reached
    # @!attribute access_key
    #   @see https://developer.github.com/v3/oauth/
    #   @return [String] Configure OAuth app key
    # @!attribute [w] secret_key
    #   @see https://developer.github.com/v3/oauth/
    #   @return [String] Configure OAuth app secret
    # @!attribute connection_options
    #   @see https://github.com/lostisland/faraday
    #   @return [Hash] Configure connection options for Faraday
    # @!attribute middleware
    #   @see https://Rancher.com/lostisland/faraday
    #   @return [Faraday::Builder or Faraday::RackBuilder] Configure middleware for Faraday
    # @!attribute per_page
    #   @return [String] Configure page size for paginated results. API default: 30
    # @!attribute proxy
    #   @see https://Rancher.com/lostisland/faraday
    #   @return [String] URI for proxy server
    # @!attribute user_agent
    #   @return [String] Configure User-Agent header for requests.
    # @!attribute web_endpoint
    #   @return [String] Base URL for web URLs. default: https://rancher.com/

    attr_accessor :access_key, :secret_key, :connection_options,
                  :middleware, :proxy, :user_agent, :default_media_type
    attr_writer :api_endpoint, :api_path

    class << self

      # List of configurable keys for {Rancher::Client}
      # @return [Array] of option keys
      def keys
        @keys ||= [
          :api_endpoint,
          :api_path,
          :access_key,
          :secret_key,
          :connection_options,
          :default_media_type,
          :middleware,
          :proxy,
          :user_agent
        ]
      end
    end

    # Set configuration options using a block
    def configure
      yield self
    end

    # Reset configuration options to default values
    def reset!
      Rancher::Configurable.keys.each do |key|
        instance_variable_set(:"@#{key}", Rancher::Default.options[key])
      end
      self
    end
    alias setup reset!

    # Compares client options to a Hash of requested options
    #
    # @param opts [Hash] Options to compare with current client options
    # @return [Boolean]
    def same_options?(opts)
      opts.hash == options.hash
    end

    def api_endpoint
      File.join(@api_endpoint, "")
    end

    private

    def options
      Hash[Rancher::Configurable.keys.map{|key| [key, instance_variable_get(:"@#{key}")]}]
    end

    def fetch_access_key_and_secret(overrides = {})
      opts = options.merge(overrides)
      opts.values_at :access_key, :secret_key
    end
  end
end
