module Rancher

  # Authentication methods for {Rancher::Client}
  module Authentication

    def basic_authenticated?
      !!(@access_key && @secret_key)
    end
  end
end
