module MailServer
  module Synchronization
    class Events < Base
      def response
        client.events(last_synced_events_at.utc.strftime(DATE_TIME_FORMAT))
      end

      def save_data!
        deserialized_data.each do |broadcast_statistic_hash|
          result = ::EventInfoLead::Create.call(event_info_lead_params(broadcast_statistic_hash))

          add_operation_error(result, broadcast_statistic_hash) unless result.success?
        end
      end

      def update_synchronization_date!
        MailServerSynchronization::Update.call(last_synced_events_at: Time.zone.now)
      end

      def event_info_lead_params(params)
        {
          lead_id: find_lead_by(params.dig(:mail, :group_id), params.dig(:mail, :email_to)),
          event_info: event_info(params)
        }
      end

      def mail_serever_event_types
        {
          'OPENED' => EventInfo::OPENED,
          'UNSUBSCRIBE' => EventInfo::UNSUBSCRIBED,
          'CLICKED' => EventInfo::CLICKED,
          'RESUBSCRIBE' => EventInfo::RESUBSCRIBED
        }
      end

      def find_lead_by(broadcast_id, email)
        Lead::BroadcastLeadEmailQuery.call(email, broadcast_id).try(:id)
      end

      def event_info(params)
        {
          event_type: mail_serever_event_types[params[:event_type]],
          broadcast_id: params.dig(:mail, :group_id),
          link: params[:link]
        }
      end
    end
  end
end
