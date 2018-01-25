class Payment < ApplicationRecord
  PAYMENT_METHODS = [STRIPE = 'stripe'.freeze,
                     VENMO = 'venmo'.freeze, SQUARE = 'square'.freeze].freeze

  CURRENCIES = [USD = 'usd'.freeze].freeze

  STATUSES = [COMPLETED = 'completed'.freeze, REFUNDED = 'refunded'.freeze,
              CREATED = 'created'.freeze, INCOMPLETE = 'incomplete'.freeze,
              REBILL = 'rebill'.freeze].freeze

  TRANSACTION_TYPES = [
    SERVICE = 'SERVICE_PAYMENT'.freeze,
    FEE = 'FEE_PAYMENT'.freeze,
    BOOKING_FEE = 'BOOKING_FEE'.freeze,
    CANCELLATION_POLICY = 'CANCELLATION_POLICY_PAYMENT'.freeze
  ].freeze

  MAX_REBILL_COUNT = 5

  belongs_to :user
  belongs_to :customer, class_name: 'User'
  belongs_to :booking

  belongs_to :parent, class_name: 'Payment', foreign_key: :rebill_id
end
