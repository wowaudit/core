module Audit
  class TeamWcl < Team
    attr_accessor :output, :zones

    def refresh
      prepare
      # Requests are not made in parallel, otherwise
      # load on the Warcraft Logs API would be too high
      characters.each do |character|
        self.zones.to_set.each do |zone|
          response = HTTParty.get(uri(character, zone))
          self.output[character.id] = character.process_result(response, self.output[character.id])
        end
      end
      Writer.update_db_wcl(self.output, characters)
    end

    def prepare
      self.output = {}
      self.zones = []
      characters.each do |character|
        template = { 3 => {}, 4 => {}, 5 => {} }
        VALID_RAIDS.each_with_index do |raid, raid_index|
          if raid['days'].include? Time.now.wday
            self.zones << raid
          end
          raid['encounters'].each_with_index do |encounter, encounter_index|
            RAID_DIFFICULTIES.each_key do |difficulty|
              template[difficulty][encounter['name']] = {
                'best' => '-',
                'median' => '-',
                'average' => '-'
              }
            end
          end
        end
        self.output[character.id] = template
      end
    end

    def uri(character, zone)
      uri = WCL_URL[0 .. WCL_URL.length]
      uri["{region}"] = region
      uri["{realm}"] = Realm.to_slug(character.realm || realm)
      uri["{name}"] = CGI.escape(character.name)
      uri["{zone}"] = zone["id"].to_s
      uri["{metric}"] = character.wcl_role
      uri["{partition}"] = zone["partition"].to_s
      uri
    end

    def characters
      @characters ||= super(CharacterWcl.where(:team_id => id).to_a)
    end
  end
end
