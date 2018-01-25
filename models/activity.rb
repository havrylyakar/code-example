class Activity < ApplicationRecord
  belongs_to :activityable, polymorphic: true

  has_many :likes, dependent: :destroy

  delegate :user, to: :activityable, prefix: false, allow_nil: false
  delegate :attachment, to: :activityable, prefix: false, allow_nil: false
end
