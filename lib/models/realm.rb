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
        RBattlenet.set_options(region: realm.region, locale: "en_GB", concurrency: 50)
        Audit.timestamp = realm.region

        leaderboards = RBattlenet::Wow::MythicKeystoneLeaderboard.find(KEYSTONE_DUNGEONS.map{ |dungeon|
          {
            connected_realm_id: realm.connected_realm_id,
            dungeon_id: dungeon,
            period: Audit.period
          }
        })

        runs_by_character = {}
        leaderboards.results.map(&:leading_groups).flatten.each do |group|
          next unless group # EmptyResult will have a nil value here
          group.members.each do |member|
            (runs_by_character[member.profile.id] ||= []) << group.keystone_level
          end
        end
        runs_by_character.transform_values!(&:max)

        characters = CharacterRaiderio.where(realm: realm)
        metadata = Arango.get_characters(characters.map(&:id))
        characters = characters.to_a.map! do |character|
          character.details = metadata[character.id].to_h
          character.verify_details
          changed = character.process_leaderboard_result(runs_by_character[character.key.to_i] || 0)
          character if changed
        end.compact

        Logger.t(INFO_REALM_REFRESHED + "#{characters.size} characters updated.", id)
        Writer.update_db(characters) if characters.any?
        sleep 20
      end
    end
  end
end
