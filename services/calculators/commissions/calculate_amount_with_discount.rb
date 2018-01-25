module Calculators
  module Commissions
    module CalculateAmountWithDiscount
      def coupon
        @coupon ||= Coupon.find_by(code: options[:coupon])
      end

      def current_price
        return super unless coupon
        CalculateDiscountCouponService.new(super, coupon).calc_total
      end
    end
  end
end
