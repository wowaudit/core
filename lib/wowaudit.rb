# Ultimately this module should replace the old Audit module.
# For now it's only meant for usage as a gem wihin other projects.

require 'typhoeus'
require 'json'

require 'require_all'
require_rel './wowaudit/retrievers'
require_rel './wowaudit/results'
require_rel './wowaudit'
require_rel './models/data.rb'
require_rel './models/frozen_base.rb'
require_rel './utils/audit.rb'
require_rel './utils/season.rb'
require_rel './utils/bonus_ids.rb'
require_rel './sections'
require_rel './constants'

ALL_UPDATABLE_FIELDS = [
  :guild_profile_id, :race_id, :faction_id, :media_zone, :achievement_uid, :name,
  :level, :marked_for_deletion_at, :status, :refreshed_at, :profile_id, :gdpr_status,
  :last_status_code, :refresh_failed_at, :current_spec_id
]

module Wowaudit
  class << self
    attr_accessor :updatable_fields, :extra_fields, :failure_status, :retry_on_api_limit, :ignore_unavailable, :redis_suffix
  end

  self.updatable_fields = ALL_UPDATABLE_FIELDS.dup
  self.extra_fields = []
  self.failure_status = :does_not_exist
  self.retry_on_api_limit = true
  self.ignore_unavailable = true
  self.redis_suffix = 0

  def self.updatable_fields=(fields)
    @updatable_fields = fields.map(&:to_sym) & ALL_UPDATABLE_FIELDS
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

  def self.can_update_field?(entity, field)
    return false if updatable_fields.exclude? field.to_sym
    true
  end
end
