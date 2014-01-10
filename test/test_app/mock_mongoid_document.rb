require "virtus"

module MockMongoidDocument
  def self.included(base)
    base.const_set(:COLLECTION, [])

    base.send(:include, Virtus.model)
    base.send(:include, InstanceMethods)
    base.send(:extend, ClassMethods)

    base.send(:attribute, :_id, String)
  end

  module InstanceMethods
    def initialize(attrs = {})
      super
      self._id = self.class.const_get(:COLLECTION).count.to_s
      self.class.const_get(:COLLECTION) << self
    end

    def delete
      self.class.const_get(:COLLECTION).delete(self)
    end

    def update_attributes!(attrs)
      self.attributes = self.attributes.merge(attrs)
    end

    def as_document
      ActiveSupport::HashWithIndifferentAccess.new(self.attributes)
    end
  end

  module ClassMethods
    def all
      const_get(:COLLECTION)
    end

    def find(id)
      const_get(:COLLECTION).select { |m| m[:_id] == id }.first
    end

    def find_by(criteria)
      if criteria.keys.count > 1
        raise(StandardError, "This ain't proper Mongoid you know...")
      end
      
      const_get(:COLLECTION).select { |m| m[criteria.keys.first] == criteria[criteria.keys.first] }.first
    end

    def create!(opts = {})
      self.new(opts)
    end
  end
end
