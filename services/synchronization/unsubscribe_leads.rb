module MailServer
  module Synchronization
    class UnsubscribeLeads < Base
      def response
        client.unsubscribe_statistic(last_synced_unsubscribe_at.utc.strftime(DATE_TIME_FORMAT))
      end

      def save_data!
        deserialized_data.each do |unsubscribe_hash|
          ::Lead::UnsubscribeAllList.call(unsubscribe_hash)
        end
      end

      def update_synchronization_date!
        MailServerSynchronization::Update.call(last_synced_unsubscribe_at: Time.zone.now)
      end
    end
  end
end
