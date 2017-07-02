module Audit
  class Realm < Sequel::Model

    def to_slug(to_be_slugged = name)
      slug = to_be_slugged.gsub("'","")
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
