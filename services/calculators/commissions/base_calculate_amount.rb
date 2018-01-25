module Calculators
  module Commissions
    class BaseCalculateAmount < BaseService
      delegate :product, to: :price
      delegate :commission, to: :product, prefix: true
      delegate :commission, to: :affiliation, prefix: true, allow_nil: true
      delegate :affiliator, to: :affiliation, allow_nil: true

      attr_reader :affiliation

      def current_price
        fail NotImplementedError, 'Implement current_price method in subclass'
      end

      def call
        affiliator ? (((rate_commission.to_f / 100) * current_price).round(2)) : 0.0
      end

      def rate_commission
        fail NotImplementedError, 'Implement rate_commission method in subclass'
      end
    end
  end
end
