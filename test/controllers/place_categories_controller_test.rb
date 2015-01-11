require 'test_helper'

class PlaceCategoriesControllerTest < ActionController::TestCase
  setup do
    @place_category = place_categories(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:place_categories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create place_category" do
    assert_difference('PlaceCategory.count') do
      post :create, place_category: {  }
    end

    assert_redirected_to place_category_path(assigns(:place_category))
  end

  test "should show place_category" do
    get :show, id: @place_category
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @place_category
    assert_response :success
  end

  test "should update place_category" do
    patch :update, id: @place_category, place_category: {  }
    assert_redirected_to place_category_path(assigns(:place_category))
  end

  test "should destroy place_category" do
    assert_difference('PlaceCategory.count', -1) do
      delete :destroy, id: @place_category
    end

    assert_redirected_to place_categories_path
  end
end
