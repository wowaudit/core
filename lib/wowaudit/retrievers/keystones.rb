module Wowaudit
  module Retrievers
    class Keystones
      BATCH_SIZE = 2000
      DEFAULT_RAIDERIO = {
        'score' => 0,
        'season_highest' => 0,
        'weekly_highest' => 0,
        'period' => 0,
        'top_ten_highest' => [],
        'leaderboard_runs' => [],
      }.freeze

      def self.retrieve(realm, period)
        leaderboards = RBattlenet::Wow::MythicKeystoneLeaderboard.find(Audit::Season.current.data[:keystone_dungeons].map{ |dungeon|
          {
            connected_realm_id: realm.connected_realm_id,
            dungeon_id: dungeon[:id],
            period: period
          }
        })

        runs_by_character = {}
        leaderboards.each do |dungeon|
          if dungeon.key?(:leading_groups)
            (dungeon.dig(:leading_groups) || []).each do |group|
              next unless group && group[:members]
              group[:dungeon_id] = dungeon[:map_challenge_mode_id]
              group[:members].each do |member|
                (runs_by_character[ "#{member[:profile][:realm][:id]}-#{member[:profile][:id]}"] ||= []) << group
              end
            end
          else
            Audit::Logger.g("Got a 404 response for realm #{realm.id}, dungeon #{dungeon.dig(:map, :name)}")
          end
        end

        updates = runs_by_character.each_with_object({}) do |(profile_id, runs), output|
          output["#{realm.redis_prefix}:#{profile_id}"] = {
            runs: runs.map do |run|
              next unless run[:completed_timestamp]
              run_id = run[:completed_timestamp] / 1000
              {
                id: run_id.to_s,
                period: Audit.period_from_timestamp(run_id).to_s,
                level: run[:keystone_level],
                dungeon: run[:dungeon_id],
              }
            end.compact.uniq { |run| run[:id] },
          }
        end

        current_week = Audit.period == period
        changed = 0

        updates.keys.each_slice(BATCH_SIZE) do |batch_ids|
          metadata = Audit::Redis.get_characters(batch_ids)
          changed_docs = {}

          batch_ids.each do |redis_id|
            details = metadata[redis_id] || {}
            payload = updates[redis_id]
            next unless payload

            details_changed = false
            if !details['keystones'].is_a?(Hash)
              details['keystones'] = {}
              details_changed = true
            end

            if !details['raiderio'].is_a?(Hash)
              details['raiderio'] = DEFAULT_RAIDERIO.dup
              details_changed = true
            end

            payload[:runs].each do |run|
              if !details['keystones'][run[:period]].is_a?(Hash)
                details['keystones'][run[:period]] = {}
                details_changed = true
              end

              unless details['keystones'][run[:period]].include?(run[:id])
                details['keystones'][run[:period]][run[:id]] = {
                  "level" => run[:level],
                  "dungeon" => run[:dungeon],
                }
                details_changed = true
              end
            end

            if current_week
              levels = payload[:runs].map { |run| run[:level] }.sort.reverse
              if details['raiderio']['period'] != Audit.period || details['raiderio']['leaderboard_runs'] != levels
                details['raiderio']['weekly_highest'] = levels.max
                details['raiderio']['leaderboard_runs'] = levels
                details['raiderio']['period'] = Audit.period
                details_changed = true
              end
            end

            next unless details_changed

            changed_docs[redis_id] = details
          end

          changed += changed_docs.size
          Audit::Redis.update(changed_docs) if changed_docs.any?
        end

        Audit::Logger.t(INFO_REALM_REFRESHED + "#{changed} characters updated for period #{period}.", realm.id)
      end

      def self.retrieve_group(realm_id)
        realm = Audit::Realm.find(realm_id)
        RBattlenet.set_options(region: realm.region, namespace: realm.namespace, locale: "en_GB", concurrency: 25, response_type: :hash)
        Audit.timestamp = realm.region

        self.retrieve(realm, Audit.period)
      end
    end
  end
end
