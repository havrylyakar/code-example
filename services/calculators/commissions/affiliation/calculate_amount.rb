module Calculators
  module Commissions
    module Affiliation
      class CalculateAmount < BaseCalculateAmount
        def initialize(price, affiliation, options = {})
          @price = price
          @affiliation = affiliation
          @options = options
        end

        private

        attr_reader :price, :affiliation, :options

        def current_price
          options[:amount] || price.decorate.correct_price_amount
        end

        def rate_commission
          [affiliation_commission&.rate.to_i, product_commission.rate].max
        end
      end
    end
  end
end
