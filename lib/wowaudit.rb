require 'typhoeus'
require 'json'

require 'require_all'
require_rel './wowaudit'

ALL_UPDATABLE_FIELDS = [
  :guild, :race_id, :faction_id, :thumbnail_url, :transfer_id, :level, :marked_for_deletion_at, :status
]

module Wowaudit
  cattr_accessor(:updatable_fields) { ALL_UPDATABLE_FIELDS }
  cattr_accessor(:extended) { true }
  cattr_accessor(:retry_on_api_limit) { true }

  def self.updatable_fields=(fields)
    @@updatable_fields = fields.map(&:to_sym) & ALL_UPDATABLE_FIELDS
  end

  def self.client
    @@client ||= Wowaudit::Client.new(ENV['BLIZZARD_CLIENT_ID'], ENV['BLIZZARD_CLIENT_SECRET'])
  end

  def self.retrieve(characters, client_id = nil, client_secret = nil)
    client.authenticate(client_id, client_secret) if client_id && client_secret
    client.retrieve([characters].flatten)

    # Reset client authentication back to the default when finished with the custom credential requests
    client.authenticate(ENV['BLIZZARD_CLIENT_ID'], ENV['BLIZZARD_CLIENT_SECRET']) if client_id && client_secret
  end

  def self.update_field(entity, field, value)
    return if @@updatable_fields.exclude? field.to_sym
    entity.send("#{field}=", value)
  end
end
