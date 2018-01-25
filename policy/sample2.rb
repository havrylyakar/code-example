class FeePolicy
  class << self
    def fees_enabled?
      AdminSetting.instance.main_fee_use
    end

    def payment_for_fee?(payment)
      payment.transaction_type.eql?(Payment::SALE)
    end

    def fee_should_be_paid?(admin)
      fees_enabled? && admin
    end

    def creadential_present?(admin)
      admin.profile_pp_connected_email.present? && admin.profile_pp_permissions_granted.to_bool
    end

    def stripe_creadential_present?
      Rails.application.secrets.stripe_publishable_key.present? &&
        Rails.application.secrets.stripe_secret_key.present? &&
        Rails.application.secrets.stripe_client_id.present?
    end

    def fee_payments_available?(admin)
      fee_should_be_paid?(admin) && creadential_present?(admin) && fees_enabled?
    end

    def stripe_fee_payments_available?
      stripe_creadential_present? && fees_enabled?
    end
  end
end
