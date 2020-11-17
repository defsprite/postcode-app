# frozen_string_literal: true

class PostcodeValidationForm
  include ActiveModel::Model

  attr_accessor :postcode

  def initialize(attrs={}, lookup_service_klass=PostcodeLookupService)
    @lookup_service_klass = lookup_service_klass
    super(attrs)
  end

  def result
    @result ||= run_lookup
  end

  def valid?
    postcode.present? && result.valid?
  end

  def error_message
    return "Please enter a postcode." if postcode.blank?
    return "Oh no! We are currently unable to look up postcodes, please check back later." if result.api_error?
    return "Oh no! The postcode #{postcode} is invalid." unless result.valid?

    nil
  end

  private

  def run_lookup
    @lookup_service_klass.new(postcode: postcode).run
  end
end
