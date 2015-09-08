require 'rancher/configurable'
require 'rancher/default'
require 'rancher/authentication'
require 'rancher/connection'
require 'rancher/client/hosts'
require 'rancher/client/load_balancer_services'
require 'rancher/client/services'

module Rancher
  class Client
    include Rancher::Authentication
    include Rancher::Configurable
    include Rancher::Connection
    include Rancher::Client::Hosts
    include Rancher::Client::LoadBalancerServices
    include Rancher::Client::Services

    # Header keys that can be passed in options hash to {#get},{#head}
    CONVENIENCE_HEADERS = Set.new([:accept, :content_type])

    def initialize(options = {})
      # Use options passed in, but fall back to module defaults
      Rancher::Configurable.keys.each do |key|
        instance_variable_set(:"@#{key}", options[key] || Rancher.instance_variable_get(:"@#{key}"))
      end
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
    
  end
end
