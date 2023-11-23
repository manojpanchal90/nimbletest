require "application_system_test_case"

class KeywordsTest < ApplicationSystemTestCase
  setup do
    @keyword = keywords(:one)
  end

  test "visiting the index" do
    visit keywords_url
    assert_selector "h1", text: "Keywords"
  end

  test "should create keyword" do
    visit keywords_url
    click_on "New keyword"

    click_on "Create Keyword"

    assert_text "Keyword was successfully created"
    click_on "Back"
  end

  test "should update Keyword" do
    visit keyword_url(@keyword)
    click_on "Edit this keyword", match: :first

    click_on "Update Keyword"

    assert_text "Keyword was successfully updated"
    click_on "Back"
  end

  test "should destroy Keyword" do
    visit keyword_url(@keyword)
    click_on "Destroy this keyword", match: :first

    assert_text "Keyword was successfully destroyed"
  end
end
