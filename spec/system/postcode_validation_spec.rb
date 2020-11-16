# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Postcode validation", type: :system do
  before do
    driven_by(:rack_test)
  end

  context "when a valid postcode is given" do
    it "tells the customer when an area is not available" do
      visit "/postcode_validation/new"

      fill_in "Postcode", with: "N4 2HS"
      click_button "Validate Postcode"

      expect(page).to have_text("Oh no! The postcode N4 2HS is not available at this point.")
    end

    it "tells the customer when an area is available" do
      visit "/postcode_validation/new"

      fill_in "Postcode", with: "SE1 7QD"
      click_button "Validate Postcode"

      expect(page).to have_text("Success! The postcode SE1 7QD is available.")
    end
  end

  context "when postcodes.io is down" do
    before do
      Typhoeus.stub(/postcodes\.io/).and_return(Typhoeus::Response.new(code: 0))
    end

    it "shows an error message" do
      visit "/postcode_validation/new"

      fill_in "Postcode", with: "SE1 7QD"
      click_button "Validate Postcode"

      expect(page).to have_text("Oh no! We are currently unable to look up postcodes, please check back later.")
    end
  end

  it "shows an error for an invalid postcode" do
    visit "/postcode_validation/new"

    fill_in "Postcode", with: "FOO BAR"
    click_button "Validate Postcode"

    expect(page).to have_text("Oh no! The postcode FOO BAR is invalid.")
  end
end
