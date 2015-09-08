if RUBY_ENGINE == 'ruby'
  require 'simplecov'
  require 'coveralls'

  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter,
    Coveralls::SimpleCov::Formatter
  ]
  SimpleCov.start
end

require 'json'
require 'rancher'
require 'rspec'
require 'webmock/rspec'

WebMock.disable_net_connect!(:allow => 'coveralls.io')

RSpec.configure do |config|
  config.raise_errors_for_deprecations!
end

require 'vcr'
VCR.configure do |c|
  c.configure_rspec_metadata!

  c.ignore_request do |request|
    !!request.headers['X-Vcr-Test-Repo-Setup']
  end

  c.default_cassette_options = {
    :serialize_with => :json,
    # TODO: Track down UTF-8 issue and remove
    :preserve_exact_body_bytes => true,
    :decode_compressed_response => true,
    :record => ENV['TRAVIS'] ? :none : :once
  }
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
end

def test_rancher_api_endpoint
  ENV.fetch 'RANCHER_TEST_API_ENDPOINT', 'http://localhost:8080/v1/project/1a5'
end

def test_rancher_access_key
  ENV.fetch 'RANCHER_TEST_ACCESS_KEY', 'x' * 21
end

def test_rancher_secret_key
  ENV.fetch 'RANCHER_TEST_SECRET_KEY', 'x' * 40
end

def oauth_client
  Rancher::Client.new(
    :api_endpoint => test_rancher_api_endpoint,
    :access_key => test_rancher_access_key,
    :secret_key => test_rancher_secret_key
  )
end

def stub_delete(url)
  stub_request(:delete, rancher_url(url))
end

def stub_get(url)
  stub_request(:get, rancher_url(url))
end

def stub_head(url)
  stub_request(:head, rancher_url(url))
end

def stub_patch(url)
  stub_request(:patch, rancher_url(url))
end

def stub_post(url)
  stub_request(:post, rancher_url(url))
end

def stub_put(url)
  stub_request(:put, rancher_url(url))
end

def fixture_path
  File.expand_path("../fixtures", __FILE__)
end

def fixture(file)
  File.new(fixture_path + '/' + file)
end

def json_response(file)
  {
    :body => fixture(file),
    :headers => {
      :content_type => 'application/json; charset=utf-8'
    }
  }
end

def rancher_url(url)
  return url if url =~ /^http/

  url = File.join(Rancher.api_endpoint, url)
  uri = Addressable::URI.parse(url)
  uri.path.gsub!("1a5//", "1a5/")

  uri.to_s
end

def use_vcr_placeholder_for(text, replacement)
  VCR.configure do |c|
    c.define_cassette_placeholder(replacement) do
      text
    end
  end
end
