require 'rancher/configurable'
require 'rancher/default'
require 'rancher/authentication'
require 'rancher/connection'
require 'rancher/classify'

module Rancher
  # The Main Client for talking with Rancher
  class Client
    include Rancher::Authentication
    include Rancher::Configurable
    include Rancher::Connection
    include Rancher::Classify

    attr_reader :types

    # Header keys that can be passed in options hash to {#get},{#head}
    CONVENIENCE_HEADERS = Set.new([:accept, :content_type])

    def initialize(options = {})
      # Use options passed in, but fall back to module defaults
      @types = {}
      Rancher::Configurable.keys.each do |key|
        instance_variable_set(
          :"@#{key}",
          options[key] || Rancher.instance_variable_get(:"@#{key}")
        )
      end

      load_schema
    end

    def load_schema
      response = get 'schema'

      response.each do |res|
        @types[res.get_id.to_sym] = Rancher::Type.new(res)
      end if response.is_a?(Rancher::Collection)
    end

    # Text representation of the client, masking tokens and passwords
    #
    # @return [String]
    def inspect
      inspected = super

      if @secret_key
        inspected = inspected.gsub! @secret_key, "#{'*'*36}#{@secret_key[36..-1]}"
      end

      inspected
    end

    # Set Rancher access_key
    #
    # @param value [String] Rancher access_key
    def access_key=(value)
      reset_agent
      @access_key = value
    end

    # Set Rancher secret_key
    #
    # @param value [String] Rancher secret_key
    def secret_key=(value)
      reset_agent
      @secret_key = value
    end

    def respond_to_missing?(method_name, _include_private = false)
      (@types.key?(method_name))
    end

    def method_missing(method_name, *args, &block)
      return @types[method_name] if respond_to?(method_name)

      super
    end

  end
end
