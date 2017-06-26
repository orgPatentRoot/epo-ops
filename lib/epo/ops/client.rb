require 'epo/ops/token_store'
require 'epo/ops/error'

module Epo
  module Ops
    class Client
      # @return [OAuth2::Response]
      def self.request(verb, url, options = {})
        token = Epo::Ops.config.token_store.token
        response = token.request(verb, URI.encode(url), options)
        fail Error.from_response(response) unless response.status == 200
        response
      end
    end
  end
end