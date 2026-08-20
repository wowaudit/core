module Audit
  class Team < Sequel::Model
    one_to_many :team_ranks
    one_to_many :team_memberships

    def guild
      @guild ||= Guild.where(id: owner_id).first
    end

    def characters
      @characters ||= begin
        members = team_memberships_dataset.eager(:character).all
        characters = members.map(&:character)

        members.each_with_index do |member, index|
          character = characters[index]
          character.team_rank = ranks_by_id[member.team_rank_id]
          character.details = character_details(characters)[character.legacy_redis_id].to_h
          character.role = member.role.capitalize
          character.note = member.note
        end

        characters
      end
    end

    def spreadsheet_visible?(character)
      rank = character.team_rank
      return false unless rank

      rank.spreadsheet_summary_visibility ||
        rank.spreadsheet_roster_visibility ||
        rank.spreadsheet_overview_visibility ||
        rank.spreadsheet_vault_visibility ||
        rank.spreadsheet_profession_visibility ||
        rank.spreadsheet_raids_visibility
    end

    def warning
      if characters.any? { |character| character.gdpr_status == Wowaudit.failure_status }
        TRACK_WARNING
      else
        NO_WARNING
      end
    end

    def character_details(characters)
      @character_details ||= Redis.get_characters(characters.map(&:legacy_redis_id).compact)
    end

    def ranks_by_id
      @ranks ||= team_ranks.group_by(&:id).transform_values(&:first)
    end

    def raids_path
      "https://wowaudit.com/#{guild.path}/#{name.gsub(" ","-").downcase}/raids"
    end

    def roster_path
      "https://wowaudit.com/#{guild.path}/#{name.gsub(" ","-").downcase}/roster"
    end
  end
end
