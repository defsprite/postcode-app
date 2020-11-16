class PostcodeValidation
  include ActiveModel::Model

  attr_accessor :postcode

  def valid?
    postcode.present?
  end

  def available?
    false
  end
end
