class PostcodeLookupService

  def run(postcode)
    response = Typhoeus.get("http://postcodes.io/postcodes/%s" % requestable_postcode(postcode))
    puts response.inspect

    result = parse_json(response.body)

    PostcodeLookupResult.new(
      canonical_postcode: result.dig("result", "postcode"),
      lsoa: result.dig("result", "lsoa"),
      success?: result.fetch("status", 0) == 200
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
