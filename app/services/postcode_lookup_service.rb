# frozen_string_literal: true

class PostcodeLookupService
  attr_reader :postcode

  def initialize(postcode:)
    @postcode = postcode
  end

  def run
    if extra_postcodes.any? { |extra_code| extra_code == normalised_postcode }
      PostcodeLookupResult.new(postcode: normalised_postcode, valid: true, available: true, api_error: false)
    else
      api_lookup
    end
  end

  def api_lookup
    response = Typhoeus.get("http://postcodes.io/postcodes/%s" % normalised_postcode)
    result   = parse_json(response.body)

    PostcodeLookupResult.new(
      postcode:  result.dig("result", "postcode"),
      valid:     result.fetch("status", 0) == 200,
      available: lsoa_available?(result.dig("result", "lsoa")),
      api_error: response.code.zero? || result.empty?
    )
  end

  def lsoa_available?(lsoa)
    return false if lsoa.blank?

    lsoa_prefixes.any? { |prefix| lsoa.start_with? prefix }
  end

  private

  def lsoa_prefixes
    @lsoa_prefixes ||= PostcodeConfig.lsoa_prefixes
  end

  def extra_postcodes
    @extra_postcodes ||= PostcodeConfig.extra_postcodes.map { |pc| pc.gsub(/\s/, '').upcase }
  end

  def parse_json(str)
    JSON.parse(str || "")
  rescue JSON::JSONError => e
    Rails.logger.warn "[PostcodeLookupService] Cannot parse JSON response: #{e.message}: #{str}"
    {}
  end

  def normalised_postcode
    @normalised_postcode ||= postcode.gsub(/\s/, "").upcase
  end
end
