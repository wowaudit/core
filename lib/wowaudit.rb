# Ultimately this module should replace the old Audit module.
# For now it's only meant for usage as a gem wihin other projects.

require 'typhoeus'
require 'json'

require 'require_all'
require_rel './models/data.rb'
require_rel './utils/audit.rb'
require_rel './utils/season.rb'
require_rel './utils/bonus_ids.rb'
require_rel './sections'
require_rel './constants'
require_rel './wowaudit'

ALL_UPDATABLE_FIELDS = [
  :guild_profile_id, :race_id, :faction_id, :media_zone, :achievement_uid, :name,
  :level, :marked_for_deletion_at, :status, :refreshed_at, :profile_id, :gdpr_status,
  :last_status_code, :refresh_failed_at,
]

module Wowaudit
  cattr_accessor(:updatable_fields) { ALL_UPDATABLE_FIELDS }
  cattr_accessor(:extra_fields) { [] }
  cattr_accessor(:failure_status) { :does_not_exist }
  cattr_accessor(:extended) { true }
  cattr_accessor(:retry_on_api_limit) { true }
  cattr_accessor(:ignore_unavailable) { true }
  cattr_accessor(:redis_suffix) { 0 }

  def self.updatable_fields=(fields)
    @@updatable_fields = fields.map(&:to_sym) & ALL_UPDATABLE_FIELDS
  end

  def self.client
    @@client ||= Wowaudit::Client.new(ENV['BLIZZARD_CLIENT_ID'], ENV['BLIZZARD_CLIENT_SECRET'])
  end

  def self.retrieve(characters, client_id = nil, client_secret = nil)
    client.authenticate(client_id, client_secret) if client_id && client_secret
    result = client.retrieve([characters].flatten)

    # Reset client authentication back to the default when finished with the custom credential requests
    client.authenticate(ENV['BLIZZARD_CLIENT_ID'], ENV['BLIZZARD_CLIENT_SECRET']) if client_id && client_secret

    result
  end

  def self.update_field(entity, field, value)
    return if @@updatable_fields.exclude? field.to_sym
    entity.send("#{field}=", value)
  end
end
