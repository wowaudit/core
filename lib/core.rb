# Dependencies
require 'require_all'
require 'sequel'
require 'rbattlenet'
require 'typhoeus'
require 'aws-sdk'
require 'date'
require 'mysql2'
require 'yaml'
require 'csv'

# File Storage
storage_data = YAML::load(File.open('config/storage.yml'))
Aws.config.update(
  endpoint: storage_data["endpoint"],
  access_key_id: storage_data["access_key"],
  secret_access_key: storage_data["secret_access_key"],
  region: storage_data["region"]
)
STORAGE = Aws::S3::Resource.new
BUCKET = storage_data["bucket"]

# Connections
keys = YAML::load(File.open('config/keys.yml'))
BNET_KEY = keys["bnet_key"]
WCL_KEY = keys["wcl_key"]
RAIDERIO_KEY = keys["raiderio_key"]
DB = Sequel.connect(YAML::load(File.open('config/database.yml')))

# Modules
require_rel 'constants'
require_rel 'models'
require_rel 'sections'
require_rel 'utils'
