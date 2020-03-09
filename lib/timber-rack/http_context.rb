require "timber/contexts/http"
require "timber/current_context"
require "timber-rack/middleware"
require "timber-rack/util/request"

module Timber
  module Integrations
    module Rack
      # A Rack middleware that is reponsible for adding the HTTP context {Timber::Contexts::HTTP}.
      class HTTPContext < Middleware
        def call(env)
          request = Util::Request.new(env)
          context = Contexts::HTTP.new(
            host: request.host,
            method: request.request_method,
            path: request.path,
            remote_addr: request.remote_ip || request.ip,
            request_id: request.request_id
          )

          CurrentContext.add(context.to_hash)
          @app.call(env)
        end
      end
    end
  end
end
