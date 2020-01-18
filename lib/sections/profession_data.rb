module Audit
  class ProfessionData < Data
    def add
      professions = @data['professions']['primary'].select{ |p| PROFESSIONS.keys.include?(p['id']) }
      base_professions = @data['professions']['primary'].select{ |p| BASE_PROFESSIONS.keys.include?(p['id']) }

      professions.each_with_index do |profession, index|
        @character.data["profession_#{index + 1}"] = "#{profession['name']} (#{profession['rank']})"
      end

      if professions.size == 1
        unlearnt = base_professions.reject{ |p| professions.first['name'].include?(p['name']) }.first
        @character.data["profession_2"] = "#{unlearnt['name']} (0)" if unlearnt
      elsif professions.size == 0
        base_professions.each_with_index do |profession, index|
          @character.data["profession_#{index + 1}"] = "#{profession['name']} (0)"
        end
      end

      @character.data['cooking_rank'] =
        @data['professions']['secondary'].select{ |p| p['name'] == 'Kul Tiran Cooking' }.first['rank'] rescue 0

      # Ugly workaround to get rid of Kul Tiran
      @character.data["profession_1"].gsub!("Kul Tiran ", "") rescue ""
      @character.data["profession_2"].gsub!("Kul Tiran ", "") rescue ""
    end
  end
end
