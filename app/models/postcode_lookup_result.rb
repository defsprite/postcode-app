# frozen_string_literal: true

PostcodeLookupResult = Struct.new(:canonical_postcode, :lsoa, :valid?, :error?, keyword_init: true) do

  def available?
    return false if lsoa.nil?
    return true if PostcodeConfig.lsoa_prefixes.any? { |prefix| lsoa.start_with? prefix }

    PostcodeConfig.extra_postcodes.any? { |extra| extra == canonical_postcode }
  end
end
