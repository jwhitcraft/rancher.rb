module Rancher
  class Client
    module ServiceConsumeMaps

      # List Service Consume Maps
      #
      # @return [Array<Sawyer::Resource>] A list of Service Consume Maps
      # @example Fetch Service Consume Maps
      #   Rancher.service_consume_maps
      # @example Fetch Service Consume Maps for a specific ServiceId
      #   Rancher.service_consume_maps({:serviceId => '1s62'})
      def service_consume_maps(options = {})
        get 'serviceConsumeMaps/', options
      end
      alias :serviceConsumeMaps :service_consume_maps

      # Get a specific Service Consume Map
      #
      # @param id [String] ServiceConsumeMap ID
      # @return [Sawyer::Resource] ServiceConsumeMap information
      def service_consume_map(id, options = {})
        get "serviceConsumeMaps/#{id}/", options
      end
      alias :serviceConsumeMap :service_consume_map

      # Remove a Service Consume Map
      #
      # @param id [String] ServiceConsumeMap ID
      # @return [Boolean] Indicating success of deletion
      def delete_service_consume_map(id, options = {})
        body = post "serviceConsumeMaps/#{id}/?action=remove", options
        body.state == 'removing'
      end
    end
  end
end
