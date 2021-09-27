module Wowaudit
  class Client
    FIELDS = [:equipment]
    EXTENDED_FIELDS = [
      :achievements,
      :achievement_statistics,
      :completed_quests,
      :equipment,
      :mounts,
      :pets,
      :professions,
      :pvp_bracket_2v2,
      :pvp_bracket_3v3,
      :pvp_bracket_rbg,
      :pvp_summary,
      :season_keystones,
      :reputations,
      :soulbinds,
      :status,
      :titles,
    ]

    def initialize(client_id, client_secret)
      authenticate(client_id, client_secret)
      RBattlenet.set_options(concurrency: 50, response_type: :hash)
    end

    def retrieve(characters, output = {})
      api_limited = []

      characters.group_by(&:region).each do |region, characters|
        RBattlenet.set_options(region: region, locale: (region == "US" ? "en_US" : "en_GB"))

        RBattlenet::Wow::Character.find(
          characters.map do |ch|
            {
              name: ch.name.downcase,
              realm: ch.realm.slug,
              season: CURRENT_KEYSTONE_SEASON,
              source: ch
            }
          end, fields: (Wowaudit.extended ? EXTENDED_FIELDS : FIELDS)
        ) do |character, response|
          begin
            output[character[:source]] << Wowaudit::Result.new(character[:source], response)
          rescue ApiLimitReachedException
            api_limited << character[:source]
          end
        end
      end

      if api_limited.any?
        raise ApiLimitReachedException unless Wowaudit.retry_on_api_limit
        retrieve(api_limited, output)
      else
        update_characters(output)
        output
      end
    end

    def authenticate(client_id, client_secret)
      attempts = 0
      begin
        RBattlenet.authenticate(client_id: client_id, client_secret: client_secret)
      rescue
        attempts += 1
        if attempts < 5
          retry
        else
          raise
        end
      end

      @authenticated_at = DateTime.now
    end

    private

    def update_characters(output)
      byebug
    end
  end
end
