module Calculators
  module Commissions
    module Subscription
      class CalculateAmount < BaseCalculate
        private

        delegate :any_payments?, to: :policy

        def current_price
          subscription.decorate.next_price
        end

        def first_commission
          super unless any_payments?
        end

        def policy
          @policy ||= SubscriptionPolicy.new(subscription)
        end
      end
    end
  end
end
