require 'helper'
require 'json'

describe Rancher::Client do

  before do
    Rancher.reset!
  end

  after do
    Rancher.reset!
  end

  describe "module configuration" do

    before do
      Rancher.reset!
      Rancher.configure do |config|
        Rancher::Configurable.keys.each do |key|
          config.send("#{key}=", "Some #{key}")
        end
      end
    end

    after do
      Rancher.reset!
    end

    it "inherits the module configuration" do
      client = Rancher::Client.new
      Rancher::Configurable.keys.each do |key|
        expect(client.instance_variable_get(:"@#{key}")).to eq("Some #{key}")
      end
    end

    describe "with class level configuration" do

      before do
        @opts = {
          :connection_options => {:ssl => {:verify => false}},
        }
      end

      it "overrides module configuration" do
        client = Rancher::Client.new(@opts)
        expect(client.access_key).to eq(Rancher.access_key)
      end

      it "can set configuration after initialization" do
        client = Rancher::Client.new
        client.configure do |config|
          @opts.each do |key, value|
            config.send("#{key}=", value)
          end
        end
        expect(client.access_key).to eq(Rancher.access_key)
      end

      it "masks client secrets on inspect" do
        client = Rancher::Client.new(:secret_key => '87614b09dd141c22800f96f11737ade5226d7ba8')
        inspected = client.inspect
        expect(inspected).not_to include("87614b09dd141c22800f96f11737ade5226d7ba8")
      end
    end
  end

  describe "authentication" do
    before do
      Rancher.reset!
      @client = Rancher.client
    end

    describe "with module level config" do
      before do
        Rancher.reset!
      end
      it "sets oauth application creds with .configure" do
        Rancher.configure do |config|
          config.access_key     = '97b4937b385eb63d1f46'
          config.secret_key = 'd255197b4937b385eb63d1f4677e3ffee61fbaea'
        end
        expect(Rancher.client).to be_basic_authenticated
      end
      it "sets oauth token with module methods" do
        Rancher.access_key     = '97b4937b385eb63d1f46'
        Rancher.secret_key = 'd255197b4937b385eb63d1f4677e3ffee61fbaea'
        expect(Rancher.client).to be_basic_authenticated
      end
    end

    describe "with class level config" do
      it "sets oauth application creds with .configure" do
        @client.configure do |config|
          config.access_key     = '97b4937b385eb63d1f46'
          config.secret_key = 'd255197b4937b385eb63d1f4677e3ffee61fbaea'
        end
        expect(@client).to be_basic_authenticated
      end
      it "sets oauth token with module methods" do
        @client.access_key     = '97b4937b385eb63d1f46'
        @client.secret_key = 'd255197b4937b385eb63d1f4677e3ffee61fbaea'
        expect(@client).to be_basic_authenticated
      end
    end


  end

  describe ".agent" do
    before do
      Rancher.reset!
    end
    it "acts like a Sawyer agent" do
      expect(Rancher.client.agent).to respond_to :start
    end
    it "caches the agent" do
      agent = Rancher.client.agent
      expect(agent.object_id).to eq(Rancher.client.agent.object_id)
    end
  end # .agent

  describe ".root" do
    it "fetches the API root" do
      Rancher.reset!
      VCR.use_cassette 'root' do
        root = oauth_client.root
        expect(root.rels[:self].href).to eq(test_rancher_api_endpoint)
      end
    end
  end

  describe ".last_response", :vcr do
    it "caches the last agent response" do
      Rancher.reset!
      client = oauth_client
      expect(client.last_response).to be_nil
      client.get "/"
      expect(client.last_response.status).to eq(200)
    end
  end # .last_response

  describe ".get", :vcr do
    before(:each) do
      Rancher.reset!
    end
    it "handles headers" do
      request = stub_get("/zen").
        with(:query => {:foo => "bar"}, :headers => {:accept => "text/plain"})
      Rancher.get "/zen", :foo => "bar", :accept => "text/plain"
      assert_requested request
    end
  end # .get

  describe ".head", :vcr do
    it "handles headers" do
      Rancher.reset!
      request = stub_head("/zen").
        with(:query => {:foo => "bar"}, :headers => {:accept => "text/plain"})
      Rancher.head "/zen", :foo => "bar", :accept => "text/plain"
      assert_requested request
    end
  end # .head

  describe "when making requests" do
    before do
      Rancher.reset!
      @client = oauth_client
    end
    it "sets a custom user agent" do
      user_agent = "Mozilla/5.0 I am Spartacus!"
      root_request = stub_get("/").
        with(:headers => {:user_agent => user_agent})
      client = Rancher::Client.new(:user_agent => user_agent)
      client.get "/"
      assert_requested root_request
      expect(client.last_response.status).to eq(200)
    end
    it "sets a proxy server" do
      Rancher.configure do |config|
        config.proxy = 'http://proxy.example.com:80'
      end
      conn = Rancher.client.send(:agent).instance_variable_get(:"@conn")
      expect(conn.proxy[:uri].to_s).to eq('http://proxy.example.com')
    end
    it "passes along request headers for POST" do
      headers = {"X-Rancher-Foo" => "bar"}
      root_request = stub_post("/").
        with(:headers => headers).
        to_return(:status => 201)
      client = Rancher::Client.new
      client.post "/", :headers => headers
      assert_requested root_request
      expect(client.last_response.status).to eq(201)
    end
  end
end
