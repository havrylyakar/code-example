module MailServer
  module Synchronization
    class BroadcastStatistic < Base
      def response
        client.statistic(last_synced_statistic_at.utc.strftime(DATE_TIME_FORMAT))
      end

      def save_data!
        deserialized_data.each do |broadcast_statistic_hash|
          ::BroadcastStatistic::Update.call(broadcast_statistic_hash)
        end
      end

      def update_synchronization_date!
        MailServerSynchronization::Update.call(last_synced_statistic_at: Time.zone.now)
      end
    end
  end
end
