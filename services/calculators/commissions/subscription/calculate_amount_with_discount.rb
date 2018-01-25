module Calculators
  module Commissions
    module Subscription
      class CalculateAmountWithDiscount < CalculateAmount
        include Commissions::CalculateAmountWithDiscount
      end
    end
  end
end
