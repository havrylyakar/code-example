module Calculators
  module Commissions
    module Affiliation
      class CalculateAmountWithDiscount < CalculateAmount
        include Commissions::CalculateAmountWithDiscount
      end
    end
  end
end
