require 'helper'

describe Rancher do
  before do
    Rancher.reset!
  end

  after do
    Rancher.reset!
  end

  it "sets defaults" do
    Rancher::Configurable.keys.each do |key|
      expect(Rancher.instance_variable_get(:"@#{key}")).to eq(Rancher::Default.send(key))
    end
  end

  describe ".client" do
    it "creates an Octokit::Client" do
      expect(Rancher.client).to be_kind_of Rancher::Client
    end
    it "caches the client when the same options are passed" do
      expect(Rancher.client).to eq(Rancher.client)
    end
    it "returns a fresh client when options are not the same" do
      client = Rancher.client
      Rancher.access_key = "87614b09dd141c22800f96f11737ade5226d7ba8"
      client_two = Rancher.client
      client_three = Rancher.client
      expect(client).not_to eq(client_two)
      expect(client_three).to eq(client_two)
    end
  end

  describe ".configure" do
    Rancher::Configurable.keys.each do |key|
      it "sets the #{key.to_s.gsub('_', ' ')}" do
        Rancher.configure do |config|
          config.send("#{key}=", key)
        end
        expect(Rancher.instance_variable_get(:"@#{key}")).to eq(key)
      end
    end
  end

end
