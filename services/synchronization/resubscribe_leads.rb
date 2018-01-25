module MailServer
  module Synchronization
    class ResubscribeLeads < Base
      def response
        client.resubscribe_statistic(last_synced_resubscribe_at.utc.strftime(DATE_TIME_FORMAT))
      end

      def save_data!
        deserialized_data.each do |unsubscribe_hash|
          ::Lead::ResubscribeAllList.call(unsubscribe_hash)
        end
      end

      def update_synchronization_date!
        MailServerSynchronization::Update.call(last_synced_resubscribe_at: Time.zone.now)
      end
    end
  end
end
