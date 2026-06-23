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
          character.details = character_details(characters)[character.redis_id].to_h
          character.role = member.role.capitalize
        end

        characters.select do |character|
          (
            character.team_rank&.spreadsheet_summary_visibility ||
            character.team_rank&.spreadsheet_roster_visibility ||
            character.team_rank&.spreadsheet_overview_visibility ||
            character.team_rank&.spreadsheet_vault_visibility ||
            character.team_rank&.spreadsheet_profession_visibility ||
            character.team_rank&.spreadsheet_raids_visibility
          )
        end
      end
    end

    def character_details(characters)
      @character_details ||= Redis.get_characters(characters.map(&:redis_id).compact)
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
