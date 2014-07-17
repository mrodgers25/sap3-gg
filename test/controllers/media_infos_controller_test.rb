require 'test_helper'

class MediaInfosControllerTest < ActionController::TestCase
  setup do
    @media_info = media_infos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:media_infos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create media_info" do
    assert_difference('MediaInfo.count') do
      post :create, media_info: { media_desc: @media_info.media_desc, media_type: @media_info.media_type, url_id: @media_info.url_id }
    end

    assert_redirected_to media_info_path(assigns(:media_info))
  end

  test "should show media_info" do
    get :show, id: @media_info
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @media_info
    assert_response :success
  end

  test "should update media_info" do
    patch :update, id: @media_info, media_info: { media_desc: @media_info.media_desc, media_type: @media_info.media_type, url_id: @media_info.url_id }
    assert_redirected_to media_info_path(assigns(:media_info))
  end

  test "should destroy media_info" do
    assert_difference('MediaInfo.count', -1) do
      delete :destroy, id: @media_info
    end

    assert_redirected_to media_infos_path
  end
end
