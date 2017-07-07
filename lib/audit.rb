#Dependencies
require 'sequel'
require 'rbattlenet'
require 'typhoeus'
require 'aws-sdk'
require 'mysql2'
require 'yaml'
require 'csv'

#File Storage
require_relative('./writer')
storage_data = YAML::load(File.open('config/storage.yml'))
Aws.config.update(
  endpoint: storage_data["endpoint"],
  access_key_id: storage_data["access_key"],
  secret_access_key: storage_data["secret_access_key"],
  region: storage_data["region"]
)
STORAGE = Aws::S3::Resource.new
BUCKET = storage_data["bucket"]

#Constants
DB = Sequel.connect(YAML::load(File.open('config/database.yml')))
BNET_KEY = YAML::load(File.open('config/keys.yml'))["bnet_key"]
require_relative('./constants/constants.rb')

#Models
require_relative('./models/realm')
require_relative('./models/guild')
require_relative('./models/team')
require_relative('./models/character')

#Sections
require_relative('./sections/basic_data')

module Audit

  def self.refresh(teams)
    teams.split(',').each do |team|
      Audit::Team.where(id: team.to_i).first.refresh
    end
  end
end
