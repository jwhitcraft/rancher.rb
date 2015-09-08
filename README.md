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

## Usage

### Configuration

```ruby
Rancher.configure do |c|
  c.api_endpoint = 'http://localhost:8080/v1/projects/1a5/'
  c.access_key = 'my_access_key_here'
  c.secret_key = 'my_secret_key_here'
end
```

## Contributing

1. Fork it ( https://github.com/jwhitcraft/rancher.rb/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
