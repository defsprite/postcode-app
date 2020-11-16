class PostcodeValidation
  include ActiveModel::Model

  attr_accessor :postcode

  def valid?
    true
  end
end
