require "test_helper"

class ReciprocalsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @reciprocal = reciprocals(:one)
  end

  test "should get index" do
    get reciprocals_url
    assert_response :success
  end

  test "should get new" do
    get new_reciprocal_url
    assert_response :success
  end

  test "should create reciprocal" do
    assert_difference("Reciprocal.count") do
      post reciprocals_url, params: { reciprocal: { n_g: @reciprocal.n_g, val_n: @reciprocal.val_n, x: @reciprocal.x, y: @reciprocal.y } }
    end

    assert_redirected_to reciprocal_url(Reciprocal.last)
  end

  test "should show reciprocal" do
    get reciprocal_url(@reciprocal)
    assert_response :success
  end

  test "should get edit" do
    get edit_reciprocal_url(@reciprocal)
    assert_response :success
  end

  test "should update reciprocal" do
    patch reciprocal_url(@reciprocal), params: { reciprocal: { n_g: @reciprocal.n_g, val_n: @reciprocal.val_n, x: @reciprocal.x, y: @reciprocal.y } }
    assert_redirected_to reciprocal_url(@reciprocal)
  end

  test "should destroy reciprocal" do
    assert_difference("Reciprocal.count", -1) do
      delete reciprocal_url(@reciprocal)
    end

    assert_redirected_to reciprocals_url
  end
end
