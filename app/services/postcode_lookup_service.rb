# frozen_string_literal: true

class PostcodeLookupService
  def run(postcode)
    response = Typhoeus.get("http://postcodes.io/postcodes/%s" % requestable_postcode(postcode))
    result = parse_json(response.body)

    puts response.inspect

    PostcodeLookupResult.new(
      canonical_postcode: result.dig("result", "postcode"),
      lsoa:               result.dig("result", "lsoa"),
      valid?:             result.fetch("status", 0) == 200,
      error?:             response.code.zero?
    )
  end

  private

  def parse_json(str)
    JSON.parse(str)
  rescue JSON::JSONError => e
    Rails.logger.warn "[PostcodeLookupService] Cannot parse JSON response: #{e.message}: #{str}"
    {}
  end

  def requestable_postcode(postcode)
    CGI.escape(postcode.gsub(/\s/, "").upcase)
  end
end
