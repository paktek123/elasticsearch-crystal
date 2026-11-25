module Elasticsearch
  # Raised when the server does not identify itself as Elasticsearch
  # (missing or unexpected `X-Elastic-Product` response header).
  class UnsupportedProductError < Exception
    def initialize(message = "The client noticed that the server is not Elasticsearch and we do not support this unknown product.")
      super(message)
    end
  end
end
