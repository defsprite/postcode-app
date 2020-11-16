class PostcodeValidation
  include ActiveModel::Model

  attr_accessor :postcode

  def valid?
    false
  end
end
