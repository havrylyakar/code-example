class EventInfo
  class BroadcastUsersQuery
    attr_reader :relation

    class << self
      def call(broadcast_id, user_id, relation = EventInfo.all)
        new(relation).find(broadcast_id, user_id)
      end
    end

    def initialize(relation)
      @relation = relation
    end

    def find(broadcast_id, user_id)
      relation.joins(broadcast: :user)
              .where(users: { id: user_id }, broadcast_id: broadcast_id)
    end
  end
end
