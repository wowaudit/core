module FrozenModel
  extend ActiveSupport::Concern


  included do
    self.backend = FrozenRecord::Backends::Json

    self.base_path = File.join(File.dirname(__FILE__), '..', '..', 'config', 'data')

    add_index :id, unique: true
  end

  class_methods do
    def find(id)
      super(id.to_i)
    end

    def find_by_id(id)
      super(id.to_i)
    end
  end
end
