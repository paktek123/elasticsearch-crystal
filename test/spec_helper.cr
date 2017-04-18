require "../src/elasticsearch/api"
require "spec"
require "json"
require "yaml"

module Elasticsearch
  module Test
    class Client < Elasticsearch::API::Client
      def initialize(@settings : Hash(Symbol, Int32 | String))
        super
      end
    end
  end
end
