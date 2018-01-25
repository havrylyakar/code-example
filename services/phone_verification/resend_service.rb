module Cookies
  module PhoneVerification
    class ResendService < BaseService
      def success_flow!
        cookies[type] ? increment_value! : set_value!
      end

      def verify_captcha?
        cookies[type].to_i >=
          ::PhoneVerification::Contract::VerifyCode::ATTEMPTS[type]
      end

      private

      def increment_value!
        cookies[type] = cookies[type].to_i + 1
      end

      def type
        COOKIES_RESEND_ATTEMPTS
      end

      def default_value
        1
      end
    end
  end
end
