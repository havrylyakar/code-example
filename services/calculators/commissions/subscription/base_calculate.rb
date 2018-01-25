module Calculators
  module Commissions
    module Subscription
      class BaseCalculate < BaseCalculateAmount
        def initialize(price, subscription, options = {})
          @price = price
          @subscription = subscription
          @options = options
        end

        private

        attr_reader :price, :subscription, :options

        delegate :commission, to: :subscription, prefix: true, allow_nil: true

        def rate_commission
          first_commission || personal_commission || general_commission
        end

        def first_commission # DISCUSS THIS PART CODE ABOUT CORRECT AFFILIATION COMMISSIONS
          [
            subscription_commission.first_payment_comission,
            affiliation_commission&.first_payment_comission
          ].compact.max
        end

        def personal_commission
          [
            subscription_commission.rate,
            affiliation_commission&.rate
          ].compact.max
        end

        def general_commission
          [
            subscription_commission.rate,
            product_commission.rate
          ].compact.max
        end

        def affiliation
          @affiliation ||= options[:affiliation]
        end
      end
    end
  end
end
