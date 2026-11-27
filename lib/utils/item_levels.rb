module Audit
  module ItemLevels
    RELOAD_AFTER = 600 # seconds

    @levels = {}
    @loaded_at = {}
    @missing = Hash.new { |hash, game_version| hash[game_version] = Set.new }

    class << self
      # Returns { item_id => item_level } for a game version. Projects using core as a gem
      # have no DB connection and must set their own loader.
      attr_writer :loader

      def loader
        @loader ||= ->(game_version) { DB[:items].where(game_version: game_version).exclude(item_level: nil).select_hash(:item_id, :item_level) }
      end

      # Item IDs missing from the items table are recorded so web can resolve them
      def lookup(game_version, item_id)
        game_version = game_version.to_s
        item_id = item_id.to_i
        level = levels_for(game_version)[item_id]
        @missing[game_version] << item_id unless level
        level
      end

      def flush_missing
        @missing.each do |game_version, item_ids|
          Wowaudit::Metadata.client.sadd(unresolved_key(game_version), item_ids.to_a) if item_ids.any?
        end
        @missing.clear
      rescue ::Redis::BaseError => e
        Sentry.capture_exception(e)
      end

      def unresolved_key(game_version)
        "item_levels:unresolved:#{game_version}"
      end

      private

      def levels_for(game_version)
        if !@loaded_at[game_version] || Time.now - @loaded_at[game_version] > RELOAD_AFTER
          @levels[game_version] = begin
            loader.call(game_version)
          rescue StandardError => e
            Sentry.capture_exception(e)
            @levels[game_version] || {}
          end
          @loaded_at[game_version] = Time.now
        end

        @levels[game_version]
      end
    end
  end
end
