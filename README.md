# Rancher.rb

Talk with [Rancher](http://rancher.io) from Ruby.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rancher.rb'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rancher.rb

## Configuration

You can globally configure Rancher-rb to alawys use the same project by using the `.configure` command.
```ruby
Rancher.configure do |c|
  c.api_endpoint = 'http://localhost:8080/v1/projects/1a5/'
  c.access_key = 'my_access_key_here'
  c.secret_key = 'my_secret_key_here'
end
```

Finding Resources
--------
Each resource type in the API is available as a member of the Client.

### Listing all resources in a collection
```ruby
hosts = Rancher.host.query();
puts "There are #{hosts.length} hosts:\n";
hosts.each { |host|
  puts host.getName
}
```
    
### Filtering
Filters allow you to search a collection for resources matching a set of conditions.
```ruby
http_balancers = Rancher.loadbalancers.query({
  :publicStartPort => 80
})
```

### Getting a single Resource by ID
If you know the ID of the resource you are looking for already, you can also get it directly.
```ruby
host = Rancher.host.by_id('your-host-id');
```

## ToDo:

- Write More Tests
- Ability To Define Custom Classes for specific types

## Contributing

1. Fork it ( https://github.com/jwhitcraft/rancher.rb/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
