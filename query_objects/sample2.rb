class Notification
  class LastSyncedAtIndex
    attr_reader :relation

    VIEW_TYPES = [Notification::NEW_LIKE, Notification::NEW_REVIEW,
                  Notification::NEW_RECOMMENDATION].freeze

    def self.call(relation = ::Notification.all)
      new(relation).perform
    end

    def initialize(relation)
      @relation = relation
    end

    def perform
      relation.where(object_type: VIEW_TYPES)
    end
  end
end
