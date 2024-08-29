# TODO: migrate the core workers to also leverage the proper seasons.
#       For now, we'll just hardcode the current season.
class Season
  class << self
    def current
      @current_season ||= OpenStruct.new(id: CURRENT_SEASON, data: SEASON_DATA[CURRENT_SEASON])
    end

    def slugified_dungeon_names
      @slugified_dungeon_names ||= self.current.data[:keystone_dungeons].map do |dungeon|
        { id: dungeon[:id], name: dungeon[:name].gsub("'", "").gsub(":", "").gsub(" -", "").gsub("-", "").gsub(" ", "_").gsub(",", "").downcase }
      end
    end
  end
end
