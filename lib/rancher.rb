require 'json'
require 'rancher/client'
require 'rancher/default'
# Ruby Toolkit for the Rancher API
module Rancher
  class << self
    include Rancher::Configurable
    
    # API client based on configured options {Configurable}
    #
    # @return [Rancher::Client] API Wrapper
    def client
      return @client if defined?(@client) && @client.same_options?(options)
      @client = Rancher::Client.new(options)
    end
    
    private

    def respond_to_missing?(method_name, include_private=false)
      client.respond_to?(method_name, include_private)
    end

    def method_missing(method_name, *args, &block)
      if client.respond_to?(method_name)
        return client.send(method_name, *args, &block)
      end
      
      super
    end
  end
  
end

Rancher.setup
