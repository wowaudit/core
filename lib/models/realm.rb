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
        RBattlenet.set_options(region: realm.region, namespace: realm.namespace, locale: "en_GB", concurrency: 25, response_type: :hash)
        Audit.timestamp = realm.region

        (refresh_type == 'historical_keystones' ? (Season.current.data[:first_period]..(Audit.period - 1)).to_a : [Audit.period]).each do |period|
          leaderboards = RBattlenet::Wow::MythicKeystoneLeaderboard.find(Season.current.data[:keystone_dungeons].map{ |dungeon|
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
                  (runs_by_character[member[:profile][:id]] ||= []) << group
                end
              end
            else
              Logger.g("Got a 404 response for realm #{realm.connected_realm_id}, dungeon #{dungeon[:map_challenge_mode_id]}")
            end
          end

          characters = CharacterRaiderio.where(realm: realm)
          metadata = Redis.get_characters(characters.map(&:redis_id).compact)
          characters = characters.to_a.map! do |character|
            next unless character.redis_id
            character.details = metadata[character.redis_id] || {}
            Audit.verify_details(character, character.details, REALMS[character.realm_id])
            changed = character.process_leaderboard_result((runs_by_character[character.key.to_i] || []), Audit.period == period)
            character if changed
          end.compact

          Logger.t(INFO_REALM_REFRESHED + "#{characters.size} characters updated.", id)
          Writer.update_db(characters) if characters.any?
        end
      end
    end

    def name_for_path
      "#{blizzard_name}#{kind.to_s == 'live' ? '' : kind.to_s == 'classic_era' ? "-classic-era" : kind.to_s == 'classic_anniversary' ? "-anniversary" : kind.to_s == 'tournament' ? '-tournament' : "-classic"}"
    end

    def namespace
      {
        live: '',
        classic_progression: 'classic-',
        classic_era: 'classic1x-',
        classic_anniversary: 'classicann-',
        tournament: '',
      }[kind.to_sym] + region.downcase
    end

    def redis_prefix
      {
        live: 'warwithin',
        classic_progression: 'wotlk',
        classic_era: 'vanilla',
        classic_anniversary: 'anniversary',
        tournament: 'tournament',
      }[kind.to_sym]
    end

    # The new website database table doesn't have the `blizzard_name` attribute. Temporary workaround.
    def blizzard_name
      defined?(slug) ? slug : super
    end
  end
end
