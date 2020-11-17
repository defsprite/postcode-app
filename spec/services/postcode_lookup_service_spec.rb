# frozen_string_literal: true

require "rails_helper"

RSpec.describe PostcodeLookupService do
  let(:response) { Typhoeus::Response.new(code: response_code, body: response_body) }
  let(:response_body) { "{}" }
  let(:response_code) { 200 }

  before do
    Typhoeus.stub(/postcodes\.io/).and_return(response)
  end

  describe ".run" do
    subject { described_class.new(postcode: postcode).run }

    context "for a valid but unavailable postcode" do
      let(:postcode) { "n4 2hs" }
      let(:response_body) { file_fixture("postcode_n42hs_result.json").read }

      it "returns a successful lookup result" do
        expect(subject).to be_a(PostcodeLookupResult)
        expect(subject).to be_valid
      end

      it "returns the canonical postcode form" do
        expect(subject.postcode).to eq("N4 2HS")
      end

      it "returns the availability" do
        expect(subject).not_to be_available
      end
    end

    context "for a valid and available postcode" do
      let(:postcode) { "se1 7qd" }
      let(:response_body) { file_fixture("postcode_se17qd_result.json").read }

      it "returns a successful lookup result" do
        expect(subject).to be_a(PostcodeLookupResult)
        expect(subject).to be_valid
      end

      it "returns the canonical postcode form" do
        expect(subject.postcode).to eq("SE1 7QD")
      end

      it "returns the availability" do
        expect(subject).to be_available
      end
    end

    context "for a specifically allowed postcode" do
      let(:postcode) { "sh24 1aa" }
    end

    context "for an invalid postcode" do
      let(:postcode) { "f0 bar" }
      let(:response_body) { file_fixture("postcode_error_result.json").read }
      let(:response_code) { 404 }

      it "returns a non-successful lookup result" do
        expect(subject).to be_a(PostcodeLookupResult)
        expect(subject).not_to be_valid
      end

      it "returns an empty postcode" do
        expect(subject.postcode).to be_blank
      end
    end

    context "when the postcode service returns invalid JSON" do
      let(:postcode) { "se1 7qd" }

      let(:response_body) { "BOOM!" }
      let(:response_code) { 500 }

      it "returns an api errored lookup result" do
        expect(subject).to be_a(PostcodeLookupResult)
        expect(subject).not_to be_valid
        expect(subject).to be_api_error
      end

      it "returns an empty postcode" do
        expect(subject.postcode).to be_blank
      end

      it "logs an error message" do
        expect(Rails.logger).to receive(:warn).with(a_string_including("Cannot parse JSON"))

        subject
      end
    end

    context "when the postcode.io service errors during request" do
      let(:postcode) { "se 7qd" }
      let(:response_code) { 0 }

      it "returns an api errored lookup result" do
        expect(subject).to be_a(PostcodeLookupResult)
        expect(subject).to be_api_error
      end

      it "returns an empty postcode" do
        expect(subject.postcode).to be_blank
      end
    end
  end
end
