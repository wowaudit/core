require 'prometheus/client'
require 'prometheus/client/formats/text'

module Wowaudit
  module Metrics
    LEGACY_REQUESTS = Prometheus::Client.registry.counter(
      :legacy_blizzard_requests_total,
      docstring: 'Total Blizzard API requests made by legacy (master) blizzard workers'
    )

    class << self
      # Register the rbattlenet response callback and expose the registry over
      # HTTP for Prometheus. Called only by the blizzard worker process.
      def install!(port: 9394)
        RBattlenet.on_response { |_response| record }
        start_server(port)
      end

      def record
        LEGACY_REQUESTS.increment
      rescue StandardError
        # Instrumentation must never interfere with refresh work.
      end

      private

      def start_server(port)
        require 'webrick'

        server = WEBrick::HTTPServer.new(
          Port: port,
          BindAddress: '0.0.0.0',
          Logger: WEBrick::Log.new(File::NULL),
          AccessLog: []
        )

        server.mount_proc('/metrics') do |_req, res|
          res.status = 200
          res['Content-Type'] = Prometheus::Client::Formats::Text::CONTENT_TYPE
          res.body = Prometheus::Client::Formats::Text.marshal(Prometheus::Client.registry)
        end

        server.mount_proc('/') do |_req, res|
          res.status = 200
          res.body = "OK\n"
        end

        Thread.new { server.start }
      rescue StandardError => e
        warn "Failed to start metrics server on port #{port}: #{e.message}"
      end
    end
  end
end
