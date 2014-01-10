# encoding: utf-8

require "active_support/all"

module Tupplur
  module ModelExtensions
    def self.included(base)
      base.const_set(:EXTERNALLY_READABLE_FIELDS, ['_id'])
      base.const_set(:EXTERNALLY_ACCESSIBLE_FIELDS, [])
      base.const_set(:REST_INTERFACE, [])

      base.send(:include, InstanceMethods)
      base.send(:extend, ClassMethods)
    end

    module InstanceMethods
      def as_external_document
       doc = self.as_document
       
       # note: id fix for client side libraries like Spine.js,
       # who rely on an id attribute being present.
       doc['id'] = doc['_id']

       doc.slice(*readable_fields + ['id'])
      end

      def external_update!(document_as_hash)
        allowed_fields = filter_accessible_fields(document_as_hash)
        update_attributes!(allowed_fields)
      end

      # Does the model allow a certain REST operation?
      # If no operation given: Does the model allow any REST operation at all?
      def rest?(operation)
        if operation
          self.class.const_get(:REST_INTERFACE).include?(operation)
        else
          ! self.class.const_get(:REST_INTERFACE).empty?
        end
      end

      private

      def filter_accessible_fields(hsh)
        hsh.slice(*self.class.const_get(:EXTERNALLY_ACCESSIBLE_FIELDS).map(&:to_s))
      end

      def readable_fields
        (self.class.const_get(:EXTERNALLY_ACCESSIBLE_FIELDS) + self.class.const_get(:EXTERNALLY_READABLE_FIELDS)).map(&:to_s)
      end
    end

    module ClassMethods
      # Externally accessible fields and embedded documents.
      def externally_accessible(*fields)
        const_get(:EXTERNALLY_ACCESSIBLE_FIELDS).push(*fields)
      end

      # Externally readable fields and embedded documents.
      def externally_readable(*fields)
        const_get(:EXTERNALLY_READABLE_FIELDS).push(*fields)
      end

      # Used to define allowed REST operations (e.g. :read, :create, :update, :delete).
      # Example usage:
      # class MyModel 
      #   include Mongoid::Document
      #   include Tupplur::ModelExtensions
      #
      #   rest_interface :read, :update, :delete
      #
      def rest_interface(*operations)
        const_get(:REST_INTERFACE).push(*operations)
      end

      # Does the model allow a certain REST operation?
      # If no operation given: Does the model allow any REST operation at all?
      def rest?(operation = nil)
        if operation
          const_get(:REST_INTERFACE).include?(operation)
        else
          ! const_get(:REST_INTERFACE).empty?
        end
      end

      def rest_read(document_id = nil)
        if document_id
          rest_read_document(document_id)
        else
          rest_read_all
        end
      end

      def rest_update(document_id, client_model)
        raise Tupplur::Error::RESTOperationNotAllowed.new('update') unless self.rest?(:update)

        self.find(document_id).external_update!(client_model)
      end

      def rest_delete(document_id)
        raise Tupplur::Error::RESTOperationNotAllowed.new('delete') unless rest?(:delete)

        self.find(document_id).delete
      end

      def rest_create(client_fields)
        raise Tupplur::Error::RESTOperationNotAllowed.new('create') unless rest?(:create)

        self.external_create!(client_fields)
      end

      def rest_read_document(document_id)
        raise Tupplur::Error::RESTOperationNotAllowed.new('read') unless rest?(:read)

        self.find(document_id).as_external_document
      end

      def rest_read_all
        raise Tupplur::Error::RESTOperationNotAllowed.new('read') unless rest?(:read)

        self.all.map { |m| m.as_external_document }
      end

      def external_create!(fields)
        allowed_fields = filter_accessible_fields(fields)
        self.create!(allowed_fields)
      end

      def filter_accessible_fields(hsh)
        hsh.slice(*const_get(:EXTERNALLY_ACCESSIBLE_FIELDS).map(&:to_s))
      end

      def readable_fields
        (const_get(:EXTERNALLY_ACCESSIBLE_FIELDS) + const_get(:EXTERNALLY_READABLE_FIELDS)).map(&:to_s)
      end

    end
  end
end
