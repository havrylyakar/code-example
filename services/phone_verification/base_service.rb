module Cookies
  module PhoneVerification
    class BaseService
      def initialize(cookies)
        @cookies = cookies
      end

      private

      attr_reader :cookies

      def set_value!
        cookies[type] = default_value
      end

      def type
        fail NotImplementedError, 'For subclasses only!'
      end

      def default_value
        fail NotImplementedError, 'For subclasses only!'
      end
    end
  end
end
