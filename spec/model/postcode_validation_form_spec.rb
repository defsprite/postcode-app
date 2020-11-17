# frozen_string_literal: true

require "rails_helper"

RSpec.describe PostcodeValidationForm do
  let(:mock_service) {
    double("PostcodeLookupService", run: PostcodeLookupResult.new(result))
  }

  subject {
    described_class.new(
      { postcode: postcode },
      class_double("PostcodeLookupService", new: mock_service)
    )
  }

  let(:postcode) { "f0bar" }

  context "for a valid lookup result" do
    let(:result) {
      { valid: true, api_error: false, postcode: "bogus", available: false }
    }

    it { expect(subject).to be_valid }

    it "exposes nil error message" do
      expect(subject.error_message).to be_nil
    end

    it "exposes the result" do
      expect(subject.result.postcode).to eq("bogus")
    end
  end

  context "for an invalid result" do
    let(:result) {
      { valid: false, api_error: false, postcode: "bogus", available: false }
    }

    it { expect(subject).not_to be_valid }

    it "exposes a proper error message" do
      expect(subject.error_message).to match("The postcode f0bar is invalid")
    end

    it "exposes the result" do
      expect(subject.result.postcode).to eq("bogus")
    end

    context "due to an api error" do
      let(:result) {
        { valid: false, api_error: true, postcode: "bogus", available: false }
      }
      it { expect(subject).not_to be_valid }

      it "exposes a proper error message" do
        expect(subject.error_message).to match("We are currently unable to look up postcodes, please check back later")
      end
    end
  end

  context "when an empty postcode is given" do
    let(:postcode) { "" }
    let(:result) { { valid: true, api_error: false, postcode: "bogus", available: false } }

    it { expect(subject).not_to be_valid }

    it "exposes a proper error message" do
      expect(subject.error_message).to match("Please enter a postcode")
    end
  end
end
