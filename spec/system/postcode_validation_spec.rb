# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Postcode validation", type: :system do
  before do
    driven_by(:rack_test)
  end

  it "successfully looks up a valid postcode" do
    visit "/postcode_validation/new"

    fill_in "Postcode", with: "N4 2HS"
    click_button "Validate Postcode"

    expect(page).to have_text("Success! The postcode given is valid!")
  end

  it "shows an error for an invalid postcode" do
    visit "/postcode_validation/new"

    fill_in "Postcode", with: "FOO BAR"
    click_button "Validate Postcode"

    expect(page).to have_text("Error! The postcode given is invalid!")
  end
end
