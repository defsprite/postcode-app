# frozen_string_literal: true

class PostcodeValidationForm
  include ActiveModel::Model

  attr_accessor :postcode

  def initialize(attrs = {}, lookup_service_class = PostcodeLookupService)
    @lookup_service_class = lookup_service_class
    super(attrs)
  end

  def result
    @result ||= run_lookup
  end

  def valid?
    postcode.present? && !result.error? && result.valid?
  end

  def flash_message
    return "Oh no! We are currently unable to look up postcodes, please check back later." if result.error?
    return "Oh no! The postcode #{postcode} is invalid." unless result.valid?

    nil
  end

  private

  def run_lookup
    @lookup_service_class.new.run(postcode)
  end
end
