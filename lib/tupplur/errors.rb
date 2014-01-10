# encoding: utf-8

module Tupplur
  module Error
    class RESTOperationNotAllowed < StandardError
      def message
        "The #{@operation} REST operation is not allowed."
      end

      def initialize(operation = 'unspecified')
        @operation = operation
      end
    end

    def self.log_exception(e)
      puts "Exception: #{e}"
      puts "Message: #{e.message}"
      puts e.backtrace.join("\n")
    end
  end
end
