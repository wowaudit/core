module FrozenBase
  def self.included(base)
    base.backend = FrozenRecord::Backends::Json
    base.base_path = File.join(File.dirname(__FILE__), '..', '..', 'config', 'data')
    base.add_index :id, unique: true
    base.extend(ClassMethods)
  end

  module ClassMethods
    def find(id)
      super(id.to_i)
    end

    def find_by_id(id)
      super(id.to_i)
    end
  end
end
