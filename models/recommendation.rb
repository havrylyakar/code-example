class Recommendation < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :categories
  belongs_to :barber, class_name: 'User'

  has_one :attachment, as: :attachmentable, dependent: :destroy

  delegate :full_name, to: :user, prefix: true, allow_nil: false

  has_many :activities, as: :activityable, dependent: :destroy
end
