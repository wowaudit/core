module Audit
  class Realm < Sequel::Model
    def self.to_slug(to_be_slugged = realm)
      slug = to_be_slugged.name.gsub("'","")
      slug = slug.gsub("-","")
      slug = slug.gsub(" ","-")
      slug = slug.gsub("(","")
      slug = slug.gsub(")","")
      slug = slug.gsub("ê","e")
      slug = slug.gsub("à","a")
      slug.downcase
    end
  end
end
