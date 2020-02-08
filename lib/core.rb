# Dependencies
require 'require_all'
require 'sequel'
require 'arangorb'
require 'redis'
require 'rbattlenet'
require 'typhoeus'
require 'aws-sdk'
require 'date'
require 'mysql2'
require 'yaml'
require 'tzinfo'
require 'csv'
require 'rollbar'

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

# Load keys
keys = YAML::load(File.open('config/keys.yml'))
ROLLBAR_KEY = keys["rollbar_key"]
db_config = {}

Rollbar.configure do |config|
  config.access_token = ROLLBAR_KEY

  if `hostname`.strip == "L049.local"
    config.enabled = false
    require 'byebug'
    db_config = YAML::load(File.open('config/external_database.yml'))
  else
    db_config = YAML::load(File.open('config/database.yml'))
  end
end

begin
  # Connections
  DB = Sequel.connect(db_config['mysql'])
  DB2 = Mysql2::Client.new(db_config['mysql'])

  arango_conf = YAML::load(File.open('config/arangodb.yml'))
  ArangoServer.default_server(
    user: arango_conf['user'],
    password: arango_conf['password'],
    server: arango_conf['server'],
    port: arango_conf['port']
  )
  ArangoServer.database = arango_conf['database']
  ArangoServer.collection = arango_conf['collection']
  ArangoServer.user = arango_conf['user']
  ArangoServer.async = true
  ADB = ArangoCollection.new

  REDIS = Redis.new(url: db_config['redis']['host'], password: db_config['redis']['password'])

  # Modules
  require_rel 'constants'
  require_rel 'models'
  require_rel 'sections'
  require_rel 'utils'

  # Store realm data in memory
  REALMS = Audit::Realm.all.map{ |realm| [realm.id, realm] }.to_h

  # TODO: Figure out a way to properly fix registration race conditions
  sleep rand(0..15.0)

  zones = TYPE == "wcl" ? 1..2 : 1..8
  schedules = Audit::Schedule.where(type: TYPE).map(&:zone)
  occurrences = zones.map{ |zone| [zone, schedules.count{ |key| key == zone }] }.to_h
  ZONE, _ = occurrences.select { |_, v| v == occurrences.values.min }.first
  KEY = Audit::ApiKey.where(guild_id: nil, zone: ZONE, target: (TYPE == "wcl" ? "wcl" : "bnet")).first
  Audit.register_worker(TYPE) if REGISTER
  RBattlenet.authenticate(client_id: KEY.client_id, client_secret: KEY.client_secret) unless TYPE == "wcl"

rescue Mysql2::Error => e
  # The SQL proxy isn't always instantly available on server reboot
  # Therefore, retry connection after 5 seconds have passed
  Rollbar.error(e)
  puts "Connection to the database failed. Trying again in 5 seconds."
  sleep 5
  retry
end
