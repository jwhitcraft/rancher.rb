require 'rancher/collection'
require 'rancher/type'
require 'rancher/resource'

module Rancher
  # Convert Results into a Ruby Class
  module Classify
    def classify(data)
      classify_recursive(data)
    end

    private

    def is_object?(object)
      (object.is_a?(Sawyer::Resource) || object.is_a?(Hash))
    end

    def classify_recursive(data, depth = 0, as = 'auto')
      as = classify_type(data) if as == 'auto'

      return classify_object(data, depth) if as == 'object'
      return classify_array(data, depth) if as == 'array'

      data
    end

    def classify_type(data)
      if is_object?(data)
        return 'object'
      elsif data.is_a?(Array)
        return 'array'
      end

      'scalar'
    end

    def classify_object(data, depth)
      data.each do |key, element|
        if element.is_a?(Array)
          data[key] = classify_array(element, depth + 1)
        elsif is_object?(element) && element[:type] && data.rels[key]
          data[key] = classify_object(element, depth + 1)
        elsif element.is_a?(Sawyer::Resource)
          data[key] = element.attrs
        end
      end

      get_class(data).new(data.attrs)
    end

    def classify_array(data, depth)
      data.map { |element| classify_recursive(element, depth + 1) }
    end

    def get_class(data)
      klass = Rancher::Resource

      if data[:type]
        klass = Rancher::Collection if data[:type] == 'collection'
        klass = Rancher::Error if data[:type] == 'error'
      end

      klass
    end
  end
end
