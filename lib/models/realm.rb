module Audit
  class Realm < FrozenRecord::Base
    include FrozenModel

    class << self
      def file_path
        File.join(base_path, 'realms.json')
      end
    end

    def namespace
      {
        live: '',
        classic_progression: 'classic-',
        classic_era: 'classic1x-',
        classic_anniversary: 'classicann-',
        tournament: '',
      }[game_version.to_sym] + region.downcase
    end

    def redis_prefix
      {
        live: 'midnight',
        classic_progression: 'wotlk',
        classic_era: 'vanilla',
        classic_anniversary: 'anniversary',
        tournament: 'tournament',
      }[game_version.to_sym]
    end

    # The new website database table doesn't have the `blizzard_name` attribute. Temporary workaround.
    def blizzard_name
      defined?(slug) ? slug : super
    end
  end
end
