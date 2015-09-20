require 'rancher/resource'
module Rancher
  class Collection < Resource
    include Enumerable
    @data

    def initialize(data)
      @data = data[:data] if data.has_key?(:data)
      super(data)
    end

    def create(attrs)
      attrs = attrs.meta if attrs.is_a?(Rancher::Resource)

      Rancher.post get_link('self'), attrs
    end

    def remove!(id_or_obj)
      id = id_or_obj.get_id if id_or_obj.is_a?(Rancher::Resource)
      link = get_link('self') + "/#{id}"

      Rancher.delete link
    end

    def each
      return @data.enum_for(:each) unless block_given?

      @data.each { |d|
        yield d
      }
    end

    private

    def schema_field(name)
      type_name = get_type
      type = Rancher.types[type_name.to_sym]

      type.collection_field(name) if type

      type
    end

  end
end
