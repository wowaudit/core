module Audit
  module ClassicAnniversary
    class HeaderData

      def self.altered_header(team)
        new_header = HEADER[:classic_anniversary][0 .. HEADER[:classic_anniversary].length] #Copy the original header

        # Parse refresh time, spreadsheet expects Europe/Amsterdam time zone
        new_header[0] = Audit.now.strftime("%d-%m %H:%M")

        # Parse guild data
        new_header[1] = team.guild.name
        new_header[2] = REALMS[team.guild.realm_id]&.name
        new_header[3] = REALMS[team.guild.realm_id]&.region
        new_header[7] = team.name
        new_header[8] = team.raids_path
        new_header[9] = Audit.now
        new_header[10] = team.roster_path

        # Parse messages
        new_header[4] = "#{CURRENT_VERSION[:classic_anniversary]}|#{VERSION_MESSAGE}"
        new_header[5] = team.warning
        new_header[6] = team.guild.patron_id ? "patreon" : "no patreon"

        # Add raid bosses to header, spreadsheet relies on it being in the 141th column
        data = []
        VALID_RAIDS[:classic_anniversary].each do |raid|
          data << "#{raid['encounters'].map{|boss| boss['name']}.join('_')}@#{raid['name']}@"
        end
        new_header[142] = data.join("")

        new_header
      end
    end
  end
end
