require "application_system_test_case"

class FormSubmissionTest < ApplicationSystemTestCase
  #make sure the app is up
  test "visit landing page" do
    visit root_path
    assert_text "weather_app"
  end

  #test with valid data
  test "visit landing page and submit address form with valid data" do
  visit root_path
  fill_in "postal_code", with: "33140"
  click_on "FIND WEATHER"
  #assert_text "Form submitted!"
  assert_current_path success_path, ignore_query: true
  end

  #test with bad data
  test "visit landing page and submit address form with bad data" do
  visit root_path
  fill_in "postal_code", with: "2"
  click_on "FIND WEATHER"
  #assert_text "Form submitted!"
  assert_current_path failure_path, ignore_query: true
  end

end #class
