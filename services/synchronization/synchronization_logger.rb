module MailServer
  module Synchronization
    class SynchronizationLogger
      class << self
        def info(message)
          log(::Logger::INFO, message)
        end

        def error(message)
          log(::Logger::ERROR, message)
        end

        private

        def logger
          @logger ||= Logger.new("#{Rails.root}/log/synchronization.log")
        end

        def log(severity, message)
          logger.add(severity, message)
        end
      end
    end
  end
end
