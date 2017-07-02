#Dependencies
require 'sequel'
require 'rbattlenet'
require 'typhoeus'
require 'mysql2'
require 'yaml'

#Constants
DB = Sequel.connect(YAML::load(File.open('config/database.yml')))
BNET_KEY = YAML::load(File.open('config/keys.yml'))[0]
require_relative('./constants/constants.rb')

#Models
require_relative('./models/realm')
require_relative('./models/guild')
require_relative('./models/team')
require_relative('./models/character')


module Audit

  def self.refresh(teams)
    teams.split(',').each do |team|
      team = Audit::Team.where(:id => team).first
      puts team.key_code
    end
  end
end
