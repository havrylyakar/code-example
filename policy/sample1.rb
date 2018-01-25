class UserPolicy
  attr_accessor :current_user

  delegate :profile, to: :current_user

  def initialize(current_user)
    @current_user = current_user
  end

  def administration?
    admin? || subadmin?
  end

  def select_account_type?
    current_user.account
  end

  def admin?
    current_user.role == ::User::ADMIN
  end

  def subadmin?
    current_user.role == ::User::SUBADMIN
  end

  def phone_verified?
    current_user.phone_verified
  end

  def business?
    return false unless current_user
    current_user.role == ::User::BUSINESS
  end

  def affiliate?
    current_user.account_key == ::UserAccount::AFFILIATE
  end

  def same_user?(user)
    return false unless current_user.present?
    current_user.id == user.id
  end

  def simplified_pp_account?
    affiliate? || admin?
  end

  def logged_in?
    current_user.present?
  end

  def autoapprove_products?
    profile.autoapprove_products
  end

  def connected_payment_method?(method, profile = current_user.profile)
    send("#{method}?", profile)
  end

  def connected_affiliate_paypal?
    affiliate_paypal_email_provided? && current_user.profile_pp_permissions_granted.to_bool
  end

  def affiliate_paypal_email_provided?
    current_user.profile_pp_connected_email.present?
  end

  def affiliate_paypal_connected_but_not_approved?
    affiliate_paypal_email_provided? && !current_user.profile_pp_permissions_granted.to_bool
  end

  def secretly_saved?(profile = current_user.profile)
    profile.secretly_saved == 'true'
  end

  def available_url_business_account?(controller, action)
    user_account_permission_policy.valid_url?(controller, action)
  end

  def banned?
    current_user.state == User::BANNED
  end

  def connect_any_method?
    return connected_affiliate_paypal? if affiliate?
    any?(current_user.profile)
  end

  ...........................

  private

  ..................

  def paypal?(_profile)
    return connected_affiliate_paypal? if affiliate? || admin?
    connected_preapproved_payment? && connected_affiliate_paypal?
  end

  def stripe?(profile)
    profile.stripe_user_id.present?
  end

  def authorize_net?(profile)
    profile.login_id.present? && profile.transaction_key.present? && !secretly_saved?(profile)
  end

  def any?(profile)
    %w(paypal stripe authorize_net).any? { |method| send("#{method}?", profile) }
  end
end
