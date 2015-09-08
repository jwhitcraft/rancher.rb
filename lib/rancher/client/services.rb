module Rancher
  class Client
    module Services

      def list_services(options = {})
        get 'services', options
      end
      alias :services :list_services

      def service(id, options = {})
        get "services/#{id}", options
      end

      # Deactivate a Service
      def deactivate_service(id)
        post "services/#{id}/?action=deactivate"
      end

      # Activate a Service
      def activate_service(id)
        post "services/#{id}/?action=activate"
      end
    end
  end
end
