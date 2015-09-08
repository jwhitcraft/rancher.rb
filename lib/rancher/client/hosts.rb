module Rancher
  class Client
    module Hosts
      # List all hosts
      def list_hosts(options = {})
        get 'hosts', options
      end
      alias :hosts :list_hosts

      # Get a specific Host
      def host(id, options = {})
        get "hosts/#{id}/", options
      end
      alias :Host :host

      # Deactivate a Host
      def deactivate_host(id)
        post "hosts/#{id}/?action=deactivate"
      end

      # Activate a Host
      def activate_host(id)
        post "hosts/#{id}/?action=activate"
      end
    end
  end
end
