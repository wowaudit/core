module Audit
  class Realm < FrozenRecord::Base
    include FrozenBase

    class << self
      def file_path
        File.join(base_path, 'realms.json')
      end

      def for_ruleset(region, ruleset_id)
        find_by(game_version: 'classic_forever', region: region.to_s.upcase, ruleset_id: ruleset_id)
      end
    end

    def namespace
      {
        live: '',
        classic_progression: 'classic-',
        classic_era: 'classic1x-',
        classic_anniversary: 'classicann-',
        classic_forever: 'forever-',
        tournament: '',
      }[game_version.to_sym] + region.downcase
    end

    def redis_prefix
      {
        live: 'midnight',
        classic_progression: 'wotlk',
        classic_era: 'vanilla',
        classic_anniversary: 'anniversary',
        classic_forever: 'forever',
        tournament: 'tournament',
      }[game_version.to_sym]
    end

    # The new website database table doesn't have the `blizzard_name` attribute. Temporary workaround.
    def blizzard_name
      defined?(slug) ? slug : super
    end
  end
end
