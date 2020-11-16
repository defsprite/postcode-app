class PostcodeLookupResult < Struct.new(:canonical_postcode, :lsoa, :success?, keyword_init: true)
end
