class BookingDecorator < Draper::Decorator
  delegate_all

  delegate :service_with_price_booking,
           :service_without_price_booking, to: :service_query

  CHARGES_SERVICES = {
    Payment::STRIPE => ::Payments::Stripe::ChargeService,
    Payment::SQUARE => ::Payments::Square::ChargeService,
    Payment::VENMO => ::Payments::Venmo::ChargeService
  }.freeze

  CANCELLATION_PAYMENT_SERVICES = {
    Payment::STRIPE => ::Payments::Stripe::CancelBookingPay,
    Payment::VENMO => ::Payments::Venmo::CancelBookingPay,
    Payment::SQUARE => ::Payments::Square::CancelBookingPay
  }.freeze

  BOOKING_FEE_SERVICES = {
    Payment::STRIPE => ::Payments::Stripe::BookingFeePay,
    Payment::SQUARE => ::Payments::Square::BookingFeePay
  }.freeze

  FEE_SERVICES = {
    Payment::SQUARE => ::Payments::Square::ApplicationFeePay
  }.freeze

  TRANSACTION_SERVICES = {
    Payment::SQUARE => ::Payments::TransactionPay,
    Payment::STRIPE => ::Payments::Stripe::ChargeService
  }.freeze

  def charge_service_name
    CHARGES_SERVICES[card.service]
  end

  def cancellation_service_name
    CANCELLATION_PAYMENT_SERVICES[card.service]
  end

  def booking_fee_service_name
    BOOKING_FEE_SERVICES[card.service]
  end

  def transaction_service_name
    TRANSACTION_SERVICES[card.service]
  end

  def application_fee_service_name
    FEE_SERVICES[card.service]
  end

  def amount
    service_amount + tips_amount
  end

  def service_amount
    @service_amount ||= calc_booking_amount
  end

  def calc_booking_amount
    service_with_price_booking(id).sum('prices.value') +
      service_without_price_booking(id).sum(:price)
  end

  def service_query
    @service_query ||= ServiceQuery.new(services)
  end

  def tips_amount
    service_amount * (tips.to_f / 100)
  end
end
