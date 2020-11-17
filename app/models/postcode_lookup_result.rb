# frozen_string_literal: true

class PostcodeLookupResult
  attr_accessor :postcode, :valid, :available, :api_error

  alias valid? valid
  alias available? available
  alias api_error? api_error

  def initialize(postcode:, valid:, available:, api_error:)
    @postcode  = postcode
    @valid     = valid
    @available = available
    @api_error = api_error
  end
end
