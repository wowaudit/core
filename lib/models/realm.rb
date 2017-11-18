module Audit
  class Realm < Sequel::Model
    def self.to_slug(to_be_slugged = name)
      slug = to_be_slugged.gsub("'","")
      slug = slug.gsub("-","")
      slug = slug.gsub(" ","-")
      slug = slug.gsub("(","")
      slug = slug.gsub(")","")
      slug = slug.gsub("ê","e")
      slug = slug.gsub("à","a")
      slug.downcase
    end

    def self.wcl_realm(realm)
      Realm.where(name: realm).first.wcl_name
    end
  end
end
