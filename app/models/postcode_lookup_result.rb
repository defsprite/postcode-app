# frozen_string_literal: true

PostcodeLookupResult = Struct.new(:canonical_postcode, :lsoa, :valid?, :error?, keyword_init: true) do
end
