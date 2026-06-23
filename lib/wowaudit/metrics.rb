require 'prometheus/client'
require 'prometheus/client/formats/text'

module Wowaudit
  module Metrics
    REQUESTS = Prometheus::Client.registry.counter(
      :worker_api_requests_total,
      docstring: 'Total external API requests made by scraper workers, by worker and HTTP response code',
      labels: [:worker, :code]
    )

    class << self
      attr_reader :worker

      def install!(worker, port: 9394)
        @worker = worker.to_s
        RBattlenet.on_response { |response| record(response.code) }
        start_server(port)
      end

      def record(code)
        return unless @worker

        REQUESTS.increment(labels: { worker: @worker, code: code.to_s })
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
