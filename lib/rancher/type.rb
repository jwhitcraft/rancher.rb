require 'addressable/uri'

module Rancher
  # An Object type inside of Rancher
  class Type
    attr_reader :schema

    def initialize(schema)
      @schema = schema
    end

    def by_id(id)
      Rancher.get url(id)
    end

    def query(filters = {}, sort = {}, pagination = {}, include = {})
      opts = {
        filters: filters,
        sort: sort,
        pagination: pagination,
        include: include
      }

      link = self.class.list_href(url, opts)

      Rancher.get link
    end

    def create(attrs)
      attrs = attrs.meta if attrs.is_a?(Rancher::Resource)

      Rancher.post url attrs
    end

    def remove!(id_or_obj)
      id = id_or_obj.get_id if id_or_obj.is_a?(Rancher::Resource)

      Rancher.delete url(id)
    end

    def resource_field(name)
      if schema.in_meta?('resourceFields')
        fields = schema.get_resourceFields
      else
        fields = schema.get_fields
      end

      fields[name.to_sym] if fields[name.to_sym]
    end

    def collection_field(name)
      fields = @schema.get_collectionFields
      fields[name.to_sym] if fields[name.to_sym]
    end

    def url(id = nil)
      id = "/#{id}" unless id.nil?
      "#{@schema.get_link('collection')}#{id}"
    end

    def self.list_href(url, opts)
      qs = []
      opts ||= {}

      uri = Addressable::URI.parse(url) unless url.empty? || url.nil?
      uri.query_values.each do |key, value|
        qs.push("#{key}=#{value}")
      end if uri.query_values

      if opts[:filters]
        opts[:filters].each do |field, value|
          qs.push("#{field}=#{value}") unless value.is_a?(Array)

          if value.is_a?(Array)
            qs.concat value.map do |val|
              if val.is_a?(Hash) && (val.has_key?(:modifier) || val.has_key?(:value))
                name = "#{field}"
                name += "_#{val[:modifier]}" if val.has_key?(:modifier) && val[:modifier] != '' && val[:modifier] != 'eq'

                str = "#{name}="

                str += "#{val[:value]}" if val.has_key?(:value)

                str
              else
                "#{field}=#{val}"
              end
            end
          end
        end
      end

      if opts[:sort] && opts[:sort].key?(:name)
        qs.push("sort=#{opts[:sort][:name]}")
        qs.push('order=desc') if opts[:sort].key?(:order) && opts[:sort][:order] == 'desc'
      end

      if opts[:pagination] && opts[:pagination].key?(:limit)
        qs.push("limit=#{opts[:pagination][:limit]}")
        qs.push("marker=#{opts[:pagination][:marker]}") if opts[:pagination].key?(:marker)
      end

      qs.concat opts[:include].map do |inc|
        "include=#{inc}"
      end if opts[:include] && opts[:include].is_a?(Array)

      uri.query = qs.join('&') if qs.size > 0

      uri.to_s
    end
  end
end
