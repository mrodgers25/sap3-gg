require 'test_helper'

class StoryCategoriesControllerTest < ActionController::TestCase
  setup do
    @story_category = story_categories(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:story_categories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create story_category" do
    assert_difference('StoryCategory.count') do
      post :create, story_category: {  }
    end

    assert_redirected_to story_category_path(assigns(:story_category))
  end

  test "should show story_category" do
    get :show, id: @story_category
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @story_category
    assert_response :success
  end

  test "should update story_category" do
    patch :update, id: @story_category, story_category: {  }
    assert_redirected_to story_category_path(assigns(:story_category))
  end

  test "should destroy story_category" do
    assert_difference('StoryCategory.count', -1) do
      delete :destroy, id: @story_category
    end

    assert_redirected_to story_categories_path
  end
end
