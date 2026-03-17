module Wowaudit
  module Retrievers
    class Keystones
      def self.retrieve(realm, period)
        leaderboards = RBattlenet::Wow::MythicKeystoneLeaderboard.find(Audit::Season.current.data[:keystone_dungeons].map{ |dungeon|
          {
            connected_realm_id: realm.connected_realm_id,
            dungeon_id: dungeon[:id],
            period: period - 15
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
            Audit::Logger.g("Got a 404 response for realm #{realm.connected_realm_id}, dungeon #{dungeon[:map_challenge_mode_id]}")
          end
        end

        characters = Character.where(realm_id: realm.id)
        metadata = Redis.get_characters(characters.map(&:redis_id).compact)
        characters = characters.to_a.map! do |character|
          next unless character.redis_id
          character.details = metadata[character.redis_id] || {}
          Audit.verify_details(character, character.details, REALMS[character.realm_id])
          changed = character.process_leaderboard_result((runs_by_character[character.key.to_i] || []), Audit.period == period)
          character if changed
        end.compact

        Audit::Logger.t(INFO_REALM_REFRESHED + "#{characters.size} characters updated.", id)
        Writer.update_db(characters) if characters.any?
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
