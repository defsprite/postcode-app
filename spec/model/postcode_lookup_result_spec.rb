# frozen_string_literal: true

require "rails_helper"

RSpec.describe PostcodeLookupResult do
  subject(:main_subject) { described_class.new(canonical_postcode: postcode, lsoa: lsoa) }

  let(:postcode) { "F0 BAR" }
  let(:lsoa) { "Foobar 2AF" }

  describe "#available?" do
    subject { main_subject.available? }

    context "when the LSOA starts with 'Southwark'" do
      let(:lsoa) { "Southwark foobar" }
      it { expect(subject).to be_truthy }
    end

    context "when the LSOA starts with 'Lambeth'" do
      let(:lsoa) { "Lambeth foobar" }

      it { expect(subject).to be_truthy }
    end

    context "when the postcode is included in the override list" do
      let(:postcode) { "SH24 1AA" }

      it { expect(subject).to be_truthy }
    end

    context "for any other postcode" do
      it { expect(subject).to be_falsey }
    end
  end
end
