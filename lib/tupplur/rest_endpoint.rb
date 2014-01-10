# encoding: utf-8

require 'cuba'

module Tupplur
  class RESTEndpoint < Cuba
    attr_reader :model

    def initialize(model)
      @model = model
      super() do
        on ":id" do |document_id|
          # REST read document
          on get do
            begin
              send_json(@model.rest_read(document_id))
            rescue Tupplur::Error::RESTOperationNotAllowed => e
              res.status = 401
            end
          end

          # REST update document
          on put, param('data') do |client_model|
            begin
              send_json(@model.rest_update(document_id, client_model))
            rescue Tupplur::Error::RESTOperationNotAllowed => e
              res.status = 401
            end
          end
          
          # REST delete document
          on delete do
            begin
              send_json(@model.rest_delete(document_id))
            rescue Tupplur::Error::RESTOperationNotAllowed => e
              res.status = 401
            end
          end
        end

        # REST read whole collection
        on get do
          begin
            send_json(@model.rest_read)
          rescue Tupplur::Error::RESTOperationNotAllowed => e
            res.status = 401
          end
        end

        # REST create document
        on post, param('data') do |client_fields|
          begin
            @model.rest_create(client_fields)
          rescue Tupplur::Error::RESTOperationNotAllowed => e
            res.status = 401
          end
        end
      end
    end

    def self.define
      raise NotImplementedError, "Use .new and run the app instead."
    end

    private

    def send_json(document)
      res['Content-Type'] = 'application/json; charset=utf-8'
      res.write(document.to_json)
    end

  end
end
