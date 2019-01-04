require "timber/config"
require "timber/events/error"
require "timber/integrations/rack/middleware"
require "timber/util"

module Timber
  module Integrations
    module Rack
      # A Rack middleware that is reponsible for capturing exception and error events
      # {Timber::Events::Error}.
      class ErrorEvent < Middleware
        def call(env)
          begin
            status, headers, body = @app.call(env)
          rescue Exception => exception
            Config.instance.logger.fatal do
              Events::Error.new(
                name: exception.class.name,
                error_message: exception.message,
                backtrace: exception.backtrace
              )
            end

            raise exception
          end
        end
      end
    end
  end
end
