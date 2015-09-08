module Rancher
  module LinkParsers

    class Rancher

      def parse(data)
        links = data.delete(:links)

        return data, links
      end

    end

  end
end
