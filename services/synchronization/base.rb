module MailServer
  module Synchronization
    class Base
      DATE_TIME_FORMAT = '%Y-%m-%d %T.%L'.freeze

      attr_reader :client, :errors, :failed_operations

      delegate :last_synced_unsubscribe_at,
               :last_synced_resubscribe_at,
               :last_synced_events_at,
               :last_synced_statistic_at, to: :synchronization
      delegate :deserialized_data, :deserialize_errors, to: :deserializer

      def initialize
        @client = ::MailServerActionmailer::Api::ServerClient.new
        @errors = []
        @failed_operations = []
      end

      def perform!
        deserializer.errors? && (return deserialization_errors)
        save_data!
        update_synchronization_date!
      end

      def deserializer
        @deserializer ||= MailServer::ResponseDeserializer.new(response)
      end

      def synchronization
        @synchronization ||= MailServerSynchronization.instance
      end

      def deserialization_errors
        @errors = [*deserialize_errors]
      end

      def add_operation_error(result, income)
        error = { params: result['contract.default.params'],
                  errors: result['contract.default'].errors,
                  operation: to_s,
                  income: income }

        failed_operations << error
      end
    end
  end
end
