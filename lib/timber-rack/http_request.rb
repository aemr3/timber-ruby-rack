require "timber/util"

module Timber
  module Integrations
    module Rack
      # The HTTP server request event tracks incoming HTTP requests to your HTTP server.
      # Such as unicorn, webrick, puma, etc.
      #
      # @note This event should be installed automatically through integrations,
      #   such as the {Integrations::ActionController::LogSubscriber} integration.
      class HTTPRequest
        BODY_MAX_BYTES = 8192.freeze
        HEADERS_JSON_MAX_BYTES = 8192.freeze
        HEADERS_TO_SANITIZE = ['authorization', 'x-amz-security-token'].freeze
        HOST_MAX_BYTES = 256.freeze
        METHOD_MAX_BYTES = 20.freeze
        PATH_MAX_BYTES = 2048.freeze
        QUERY_STRING_MAX_BYTES = 2048.freeze
        REQUEST_ID_MAX_BYTES = 256.freeze
        SCHEME_MAX_BYTES = 20.freeze
        SERVICE_NAME_MAX_BYTES = 256.freeze

        attr_reader :body, :content_length, :headers, :headers_json, :host, :method, :path, :port,
          :query_string, :request_id, :scheme, :service_name

        def initialize(attributes)
          normalizer = Util::AttributeNormalizer.new(attributes)
          body_limit = attributes.delete(:body_limit) || BODY_MAX_BYTES
          headers_to_sanitize = HEADERS_TO_SANITIZE + (attributes.delete(:headers_to_sanitize) || [])

          @body = normalizer.fetch(:body, :string, :limit => body_limit)
          @content_length = normalizer.fetch(:content_length, :integer)
          @headers= normalizer.fetch(:headers, :hash, :sanitize => headers_to_sanitize)
          @headers_json = @headers.to_json.byteslice(0, HEADERS_JSON_MAX_BYTES)
          @host = normalizer.fetch(:host, :string, :limit => HOST_MAX_BYTES)
          @method = normalizer.fetch!(:method, :string, :upcase => true, :limit => METHOD_MAX_BYTES)
          @path = normalizer.fetch(:path, :string, :limit => PATH_MAX_BYTES)
          @port = normalizer.fetch(:port, :integer)
          @query_string = normalizer.fetch(:query_string, :string, :limit => QUERY_STRING_MAX_BYTES)
          @scheme = normalizer.fetch(:scheme, :string, :limit => SCHEME_MAX_BYTES)
          @request_id = normalizer.fetch(:request_id, :string, :limit => REQUEST_ID_MAX_BYTES)
          @service_name = normalizer.fetch(:service_name, :string, :limit => SERVICE_NAME_MAX_BYTES)
        end

        def message
          'Started %s "%s"' % [method, path]
        end
      end
    end
  end
end
