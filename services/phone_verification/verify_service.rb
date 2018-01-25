module Cookies
  module PhoneVerification
    class VerifyService < BaseService
      def fail_flow!
        cookies[type] ? destroy_or_decrement_value! : set_value!
      end

      def success_flow!
        cookies.delete(COOKIES_VERIFY_ATTEMPTS)
        cookies.delete(COOKIES_RESEND_ATTEMPTS)
      end

      private

      def destroy_or_decrement_value!
        cookies[type].to_i.positive? ? decrement_value! : cookies.delete(type)
      end

      def decrement_value!
        cookies[type] = cookies[type].to_i - 1
      end

      def type
        COOKIES_VERIFY_ATTEMPTS
      end

      def default_value
        ::PhoneVerification::Contract::VerifyCode::ATTEMPTS[COOKIES_VERIFY_ATTEMPTS]
      end
    end
  end
end
