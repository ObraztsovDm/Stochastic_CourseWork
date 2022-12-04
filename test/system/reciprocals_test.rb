require "application_system_test_case"

class ReciprocalsTest < ApplicationSystemTestCase
  setup do
    @reciprocal = reciprocals(:one)
  end

  test "visiting the index" do
    visit reciprocals_url
    assert_selector "h1", text: "Reciprocals"
  end

  test "should create reciprocal" do
    visit reciprocals_url
    click_on "New reciprocal"

    fill_in "N g", with: @reciprocal.n_g
    fill_in "Val n", with: @reciprocal.val_n
    fill_in "X", with: @reciprocal.x
    fill_in "Y", with: @reciprocal.y
    click_on "Create Reciprocal"

    assert_text "Reciprocal was successfully created"
    click_on "Back"
  end

  test "should update Reciprocal" do
    visit reciprocal_url(@reciprocal)
    click_on "Edit this reciprocal", match: :first

    fill_in "N g", with: @reciprocal.n_g
    fill_in "Val n", with: @reciprocal.val_n
    fill_in "X", with: @reciprocal.x
    fill_in "Y", with: @reciprocal.y
    click_on "Update Reciprocal"

    assert_text "Reciprocal was successfully updated"
    click_on "Back"
  end

  test "should destroy Reciprocal" do
    visit reciprocal_url(@reciprocal)
    click_on "Destroy this reciprocal", match: :first

    assert_text "Reciprocal was successfully destroyed"
  end
end
