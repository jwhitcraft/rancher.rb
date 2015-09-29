module Rancher
  class Resource

    @meta = {}
    @links = []
    @actions = []

    attr_reader :links, :meta

    def initialize(body = nil)
      @meta = {}

      if body
        body.each { |key, val|
          @links = val if key == :links
          @actions = val if key == :actions
          continue if key == :body
          @meta[key] = val unless key == :links or key == :actions
        }
      end
    end

    def save!
      Rancher.put get_link('self'), @meta
    end

    def remove!
      Rancher.delete get_link('self')
    end

    def get_link(name)
      @links[name.to_sym] if @links[name.to_sym]
    end

    def action?(name)
      !!@actions[name.to_sym]
    end

    def in_meta?(name)
      !!@meta[name.to_sym]
    end

    def action(name, *args)
      if action?(name)
        opt = args[0] || {}
        link = @actions[name.to_sym]
        return Rancher.post link, opt
      end
    end

    def method_missing(method_name, *args, &block)
      str_method_name = method_name.to_s
      if str_method_name.start_with?('fetch')
        name = str_method_name[6..-1]
        do_fetch(name, *args)
      elsif str_method_name.start_with?('get')
        name = str_method_name[4..-1]
        if @meta.has_key?(name.to_sym)
          ## Todo Handle TS return in seconds
          @meta[name.to_sym]
        else
          field = schema_field(name)
          raise("Attempted to access unknown property '#{name}'") if field.nil?
          nil
        end
      elsif str_method_name.start_with?('set')
        name = str_method_name[4..-1]
        @meta[name.to_sym] = args[0]
        true
      elsif str_method_name.start_with?('do')
        name = str_method_name[3..-1]
        @meta[name.to_sym] = args[0]
        action(name, *args)
      elsif str_method_name.start_with?('can')
        name = str_method_name[4..-1]
        action?(name)
      end
    end

    private
    def do_fetch(name, *args)
      opts = args[0] || {}
      link = Rancher::Type.list_href(get_link(name), opts)

      Rancher.get link if link
    end

    def schema_field(name)
      type_name = get_type
      type = Rancher.types[type_name.to_sym]

      type.resource_field(name) unless type.nil?
    end
  end
end
