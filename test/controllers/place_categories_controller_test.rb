require 'test_helper'

class PlaceGroupingsControllerTest < ActionController::TestCase
  setup do
    @place_grouping = place_groupings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:place_groupings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create place_grouping" do
    assert_difference('PlaceGrouping.count') do
      post :create, place_grouping: {  }
    end

    assert_redirected_to place_grouping_path(assigns(:place_grouping))
  end

  test "should show place_grouping" do
    get :show, id: @place_grouping
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @place_grouping
    assert_response :success
  end

  test "should update place_grouping" do
    patch :update, id: @place_grouping, place_grouping: {  }
    assert_redirected_to place_grouping_path(assigns(:place_grouping))
  end

  test "should destroy place_grouping" do
    assert_difference('PlaceGrouping.count', -1) do
      delete :destroy, id: @place_grouping
    end

    assert_redirected_to place_groupings_path
  end
end
