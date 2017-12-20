require_relative('../lib/core')

def copy_all
  characters = Audit::Character.all
  docs = []
  characters.each do |character|
    docs << transform_and_create(character)
    puts "Created document for character #{character.id}"

    if docs.size % 250 == 0
      ADB.create_document document: docs
      puts "Stored documents for 100 characters"
      docs = []
    end
  end
  ADB.create_document document: docs
end

def transform_and_create(character)
  # Transform snapshots to the new format
  snapshots = character.old_snapshots.split("|") rescue []
  current_week = Date.today.cweek #CHANGE IF THIS RUNS MON/TUES
  new_format_snapshots = { Date.today.year => {} }
  snapshots.reverse.each do |snapshot|
    begin
      new_format_snapshots[Date.today.year][current_week] = JSON.parse snapshot
    rescue
      nil
    end
    current_week -= 1
  end

  # Transform legendaries to the new format
  legendaries = character.legendaries.split('|') rescue []
  new_format_legendaries = []
  legendaries.each do |legendary|
    legendary_data = legendary.split('_')
    new_format_legendaries << {
      id: legendary_data[0],
      name: legendary_data[1]
    }
  end

  # Transform spec data to the new format
  specs = character.per_spec.split('|')[0..3] rescue ["0_0","0_0","0_0","0_0"]
  new_format_specs = {}
  specs.each_with_index do |spec, index|
    new_format_specs[index + 1] = {
      traits: spec.split('_')[0],
      ilvl: spec.split('_')[1]
    }
  end

  # Transform raider.io data to the new format
  new_format_raiderio = (JSON.parse character.raiderio rescue {})
  new_format_raiderio['weekly_highest'] = character.raiderio_weekly

  # Transform Warcraft Logs data to the new format
  wcl_data = JSON.parse character.warcraftlogs rescue nil
  warcraftlogs_id = wcl_data["character_id"] rescue nil
  new_format_wcl = {3 => {}, 4 => {}, 5 => {}}
  new_format_wcl.keys.each do |metric|
    WCL_IDS.each do |id|
      new_format_wcl[metric][id] = { "best" => "-", "median" => "-", "average" => "-" }
    end
  end
  if wcl_data
    wcl_data.each do |metric, values|
      next if metric == "character_id"
      metric, difficulty = metric.split('_')
      values.each_with_index do |value, index|
        new_format_wcl[difficulty.to_i][WCL_IDS[index]][metric] = value
      end rescue nil
    end
  end

  # Transform tier data to the new format
  new_format_tier = JSON.parse character.tier_data rescue nil
  new_format_pantheon = {
    type: (new_format_tier["trinket"].split('_')[1] rescue nil),
    ilvl: (new_format_tier["trinket"].split('_')[0] rescue nil)
  }
  new_format_tier.delete("trinket") if new_format_tier

  # Create document
  ArangoDocument.new(key: character.id.to_s, body: {
    team_id: character.team_id,
    character_id: character.id,
    warcraftlogs_id: warcraftlogs_id,
    legendaries: new_format_legendaries,
    snapshots: new_format_snapshots,
    tier_data: new_format_tier,
    spec_data: new_format_specs,
    pantheon_trinket: new_format_pantheon,
    raiderio: new_format_raiderio,
    warcraftlogs: new_format_wcl,
    last_refresh: ([HEADER, (JSON.parse character.last_refresh)].transpose.to_h rescue [])
  })
end

copy_all
