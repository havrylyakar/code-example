module MailServer
  module Synchronization
    class ServiceRunner
      attr_reader :logger, :sync_service, :description

      def self.call(sync_service, options = {})
        new(sync_service, options).perform!
      end

      def perform!
        sync_service.perform!
        sync_service.errors.present? ? failure_log : success_log
        operations_error_log(sync_service.failed_operations) if sync_service.failed_operations.present?
      end

      def initialize(sync_service, options)
        @logger = options.fetch(:logger, default_logger)
        @sync_service = sync_service.new
        @description = options.fetch(:description, default_description)
      end

      private

      def default_logger
        MailServer::Synchronization::SynchronizationLogger
      end

      def default_description
        "Service #{sync_service.class}"
      end

      def success_log
        logger.info("#{description} was successful")
      end

      def failure_log
        logger.error("#{description} was failed! Response: #{sync_service.errors}")
      end

      def operations_error_log(error_list)
        error_list.each { |error| logger.error("#{error[:operation]} was failed with errors #{error[:errors]}, incoming params: #{error[:income]},  op.params: #{error[:params]}") }
      end
    end
  end
end
