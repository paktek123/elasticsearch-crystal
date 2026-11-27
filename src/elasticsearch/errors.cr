require "json"

module Elasticsearch
  # Base class for all errors raised by this client.
  class Error < Exception
  end

  # Raised when the server cannot be reached (refused, DNS failure, reset, ...).
  class ConnectionError < Error
  end

  # Raised when a request to the server times out.
  class ConnectionTimeout < ConnectionError
  end

  # Raised when Elasticsearch answers with a 4xx/5xx status.
  class ApiError < Error
    getter status : Int32
    getter body : JSON::Any | String
    getter error_type : String?
    getter reason : String?

    def initialize(@status : Int32, @body : JSON::Any | String = "", @error_type : String? = nil, @reason : String? = nil)
      super("[#{@status}] #{@error_type}#{@reason ? ": #{@reason}" : ""}".rstrip)
    end
  end

  class BadRequestError < ApiError; end     # 400
  class AuthenticationError < ApiError; end # 401
  class AuthorizationError < ApiError; end  # 403
  class NotFoundError < ApiError; end       # 404
  class ConflictError < ApiError; end       # 409
end
