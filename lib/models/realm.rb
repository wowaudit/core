module Audit
  class Realm < Sequel::Model
    class << self
      def to_slug(to_be_slugged = realm)
        slug = to_be_slugged.name.gsub("'","")
        slug = slug.gsub("-","")
        slug = slug.gsub(" ","-")
        slug = slug.gsub("(","")
        slug = slug.gsub(")","")
        slug = slug.gsub("ê","e")
        slug = slug.gsub("à","a")
        slug.downcase
      end

      def refresh(id, refresh_type)
        realm = Realm.where(id: id).first
        RBattlenet.set_options(region: realm.region, locale: "en_GB", concurrency: 50, response_type: :hash)
        Audit.timestamp = realm.region

        (refresh_type == 'historical_keystones' ? (FIRST_PERIOD_OF_SEASON..(Audit.period - 1)).to_a : [Audit.period]).each do |period|
          leaderboards = RBattlenet::Wow::MythicKeystoneLeaderboard.find(LEADERBOARD_KEYSTONE_DUNGEONS.keys.map{ |dungeon|
            {
              connected_realm_id: realm.connected_realm_id,
              dungeon_id: dungeon,
              period: period
            }
          })

          runs_by_character = {}
          leaderboards.results.each do |dungeon|
            if dungeon.key?('leading_groups')
              (dungeon.dig('leading_groups') || []).each do |group|
                next unless group && group['members']
                group['dungeon_id'] = dungeon[:source][:dungeon_id]
                group['members'].each do |member|
                  (runs_by_character[member['profile']['id']] ||= []) << group
                end
              end
            else
              Logger.g("Got a 404 response for realm #{realm.connected_realm_id}, dungeon #{dungeon[:source][:dungeon_id]}")
            end
          end

          characters = CharacterRaiderio.where(realm: realm)
          metadata = Redis.get_characters(characters.map(&:redis_id).compact)
          characters = characters.to_a.map! do |character|
            next unless character.redis_id
            character.details = metadata[character.redis_id] || {}
            character.verify_details
            changed = character.process_leaderboard_result((runs_by_character[character.key.to_i] || []))
            character if changed
          end.compact

          Logger.t(INFO_REALM_REFRESHED + "#{characters.size} characters updated.", id)
          Writer.update_db(characters) if characters.any?
        end
      end
    end
  end
end
