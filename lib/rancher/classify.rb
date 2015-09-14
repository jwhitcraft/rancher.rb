require 'rancher/collection'
require 'rancher/type'
require 'rancher/resource'

module Rancher
  module Classify

    def classify(data)
      classify_recursive(data)
    end

    private

    def is_object?(object)
      !!(object.is_a?(Sawyer::Resource) or object.is_a?(Hash))
    end

    def classify_recursive(data, depth = 0, as = 'auto')
      if as == 'auto'
        if is_object?(data)
          as = 'object'
        elsif data.is_a?(Array)
          as = 'array'
        else
          as = 'scalar'
        end
      end

      return classify_object(data, depth) if as == 'object'
      return classify_array(data, depth) if as == 'array'

      data
    end

    def classify_object(data, depth)
      klass = Rancher::Resource

      if data[:type]
        klass = Rancher::Collection if data[:type] == 'collection'
        klass = Rancher::Error if data[:type] == 'error'
      end

      data.each { |key, element|
        if element.is_a?(Array)
          data[key] = classify_array(element, depth+1)
        elsif is_object?(element) && element[:type] && data.rels[key]
          data[key] = classify_object(element, depth+1)
        elsif element.is_a?(Sawyer::Resource)
          data[key] = element.attrs
        end
      }

      klass.new(data.attrs)
    end

    def classify_array(data, depth)
      data.map { |element|
        classify_recursive(element, depth+1)
      }
    end
  end
end
