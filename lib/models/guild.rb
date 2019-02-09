module Audit
  class Guild < Sequel::Model

    class << self
      def deactivate_guilds
        Guild.all.each {|g| g.set_inactive if (g.days_remaining <= 0 && g.active == 1 )}
      end
    end

    def path
      "#{region.downcase}/#{slugged_realm}/#{slugged_name}"
    end

    def slugged_name
      name.gsub(" ","-").downcase
    end

    def slugged_realm
      Realm.to_slug(realm)
    end

    def days_remaining
      if patreon > 0
        60
      elsif updated_at
        60 - (Date.today - updated_at.to_date).to_i
      else
        0
      end
    end

    def set_inactive
      self.active = 0
      self.save
      puts "Deactivated guild with ID #{id}"
    end
  end
end
