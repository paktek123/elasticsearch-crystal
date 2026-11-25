require "base64"
require "openssl"
require "uri"

module Elasticsearch
  module API
    module Common
      # Value type accepted by the client settings hash.
      alias Settings = Hash(Symbol, String | Int32 | Bool)

      # Connection configuration (scheme, host, port, credentials and TLS options)
      # built from the client settings hash.
      #
      # Supported settings:
      #
      # * `:url`      - full URL, e.g. `https://user:pass@host:9200`
      # * `:scheme`   - `"http"` (default) or `"https"`
      # * `:host`     - defaults to `"localhost"`
      # * `:port`     - defaults to `9200`
      # * `:user`, `:password` - credentials for HTTP basic authentication
      # * `:ca_file`  - path to a CA certificate bundle used to verify the server
      # * `:verify`   - verify the server certificate (default `true`)
      #
      # Explicit settings take precedence over the values found in `:url`.
      # Credentials are never included in `inspect` / `to_s` output or in
      # exceptions raised by this class.
      class Config
        getter scheme : String
        getter host : String
        getter port : Int32
        getter user : String?
        getter ca_file : String?
        getter? verify : Bool

        @password : String?

        # Converts any symbol-keyed hash (e.g. `{:host => "localhost", :port => 9200}`,
        # typed `Hash(Symbol, String | Int32)`) into `Settings`.
        def self.normalize(hash : Hash(Symbol, _)) : Settings
          settings = Settings.new
          hash.each { |key, value| settings[key] = value }
          settings
        end

        def initialize(settings : Settings)
          scheme = nil
          host = nil
          port = nil
          user = nil
          password = nil

          if url = settings[:url]?
            uri = URI.parse(url.to_s)
            scheme = uri.scheme
            host = uri.hostname
            port = uri.port
            user = uri.user.try { |u| URI.decode_www_form(u) }
            password = uri.password.try { |p| URI.decode_www_form(p) }
          end

          scheme = settings[:scheme]?.try(&.to_s) || scheme || "http"
          scheme = scheme.downcase
          unless scheme == "http" || scheme == "https"
            raise ArgumentError.new("Unsupported scheme #{scheme.inspect}, expected \"http\" or \"https\"")
          end

          @scheme = scheme
          @host = settings[:host]?.try(&.to_s) || host || "localhost"
          @port = port_from(settings[:port]?) || port || 9200
          @user = settings[:user]?.try(&.to_s) || user
          @password = settings[:password]?.try(&.to_s) || password
          @ca_file = settings[:ca_file]?.try(&.to_s)
          @verify = bool_from(settings[:verify]?)
        end

        def https? : Bool
          @scheme == "https"
        end

        # Base URL without credentials, e.g. `https://localhost:9200`
        def base_url : String
          "#{@scheme}://#{@host}:#{@port}"
        end

        # Value for the `Authorization` header, or nil when no user is configured.
        def authorization_header : String?
          user = @user
          return nil unless user
          "Basic #{Base64.strict_encode("#{user}:#{@password}")}"
        end

        # Builds the TLS context for https connections, nil for plain http.
        def tls_context : OpenSSL::SSL::Context::Client?
          return nil unless https?
          context = OpenSSL::SSL::Context::Client.new
          if ca = @ca_file
            context.ca_certificates = ca
          end
          context.verify_mode = OpenSSL::SSL::VerifyMode::NONE unless @verify
          context
        end

        def inspect(io : IO) : Nil
          io << "#<" << self.class.name << " " << base_url
          io << " user=" << @user.inspect if @user
          io << " password=[REDACTED]" if @password
          io << " ca_file=" << @ca_file.inspect if @ca_file
          io << " verify=" << @verify
          io << ">"
        end

        def to_s(io : IO) : Nil
          inspect(io)
        end

        private def port_from(value) : Int32?
          case value
          when Int32  then value
          when String then value.to_i? || raise ArgumentError.new("Invalid port #{value.inspect}")
          else             nil
          end
        end

        private def bool_from(value) : Bool
          case value
          when Nil    then true
          when Bool   then value
          when String then !{"false", "0", "no", "off"}.includes?(value.downcase)
          else             true
          end
        end
      end
    end
  end
end
