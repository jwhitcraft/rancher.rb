module Rancher
  class Client

    module LoadBalancerServices

      def list_loadbalancerservices(options = {})
        get 'loadbalancerservices', options
      end
      alias :loadbalancerservices :list_loadbalancerservices

      def loadbalancerservice(id, options = {})
        get "loadbalancerservices/#{id}/", options
      end
      alias :loadBalancerService :loadbalancerservice

      def add_service_link(id, service_id, ports = [], options = {})
        options ||= {}
        options[:serviceLink] = {
          :serviceId => service_id,
          :ports => ports
        }
        post "loadbalancerservices/#{id}/?action=addservicelink", options
      end

      def remove_service_link(id, service_id, ports = [], options = {})
        options ||= {}
        options[:serviceLink] = {
          :serviceId => service_id,
          :ports => ports
        }
        post "loadbalancerservices/#{id}/?action=removeservicelink", options
      end

      # Set a full list of service links in one request
      #
      # This will remove all service links and set new ones
      def set_service_links(id, service_links = [], options = {})
        options ||= {}
        options[:serviceLinks] = service_links
        post "loadbalancerservices/#{id}/?action=setservicelinks", options
      end

      # Deactivate a Load Balancer Service
      def deactivate_loadbalacnerservice(id)
        post "loadbalancerservices/#{id}/?action=deactivate"
      end
      alias :deactivate_lb_service :deactivate_loadbalacnerservice

      # Activate a Load Balancer Service
      def activate_loadbalacnerservice(id)
        post "loadbalancerservices/#{id}/?action=activate"
      end
      alias :activate_lb_service :activate_loadbalacnerservice
    end
  end
end
