require "timber/util"

module Timber
  module Integrations
    module Rack
      # The HTTP server response event tracks outgoing HTTP responses that you send
      # to clients.

      class HTTPResponse
        BODY_MAX_BYTES = 8192.freeze
        HEADERS_JSON_MAX_BYTES = 256.freeze
        HEADERS_TO_SANITIZE = ['authorization', 'x-amz-security-token'].freeze
        REQUEST_ID_MAX_BYTES = 256.freeze
        SERVICE_NAME_MAX_BYTES = 256.freeze

        attr_reader :body, :content_length, :headers, :headers_json, :http_context, :request_id, :service_name,
          :status, :duration_ms

        def initialize(attributes)
          normalizer = Util::AttributeNormalizer.new(attributes)
          body_limit = attributes.delete(:body_limit) || BODY_MAX_BYTES
          headers_to_sanitize = HEADERS_TO_SANITIZE + (attributes.delete(:headers_to_sanitize) || [])

          @body = normalizer.fetch(:body, :string, :limit => body_limit)
          @content_length = normalizer.fetch(:content_length, :integer)
          @headers = normalizer.fetch(:headers, :hash, :sanitize => headers_to_sanitize)
          @headers_json = @headers.to_json.byteslice(0, HEADERS_JSON_MAX_BYTES)
          @http_context = attributes[:http_context]
          @request_id = normalizer.fetch(:request_id, :string, :limit => REQUEST_ID_MAX_BYTES)
          @service_name = normalizer.fetch(:service_name, :string, :limit => SERVICE_NAME_MAX_BYTES)
          @status = normalizer.fetch!(:status, :integer)
          @duration_ms = normalizer.fetch!(:duration_ms, :float, :precision => 6)
        end

        # Returns the human readable log message for this event.
        def message
          if http_context
            message = "#{http_context[:method]} #{http_context[:path]} completed with " \
              "#{status} #{status_description} "

            if content_length
              message << ", #{content_length} bytes, "
            end

            message << "in #{duration_ms}ms"
          else
            message = "Completed #{status} #{status_description} "

            if content_length
              message << ", #{content_length} bytes, "
            end

            message << "in #{duration_ms}ms"
          end
        end

        def status_description
          ::Rack::Utils::HTTP_STATUS_CODES[status]
        end
      end
    end
  end
end
