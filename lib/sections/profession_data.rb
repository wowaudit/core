module Audit
  class ProfessionData < Data
    def add
      if @data[:professions].class == RBattlenet::HashResult && @data[:professions]['primaries']
        professions = @data[:professions]['primaries'].select{ |p| BASE_PROFESSIONS.keys.include?(p['profession']['id']) }

        professions.each_with_index do |profession, index|
          tier = (profession['tiers'] || []).select{ |tier| SL_PROFESSIONS.keys.include?(tier['tier']['id']) }.first
          @character.data["profession_#{index + 1}"] = "#{profession['profession']['name']} (#{tier ? tier['skill_points'] : '0'})"
        end
      end
    end
  end
end
