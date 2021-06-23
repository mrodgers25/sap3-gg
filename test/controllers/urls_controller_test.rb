require 'test_helper'

class UrlsControllerTest < ActionController::TestCase
  before do
    @url = urls(:one)
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:urls)
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create url' do
    assert_difference('Url.count') do
      post :create, params: { url: { url: @url.url, url_desc: @url.url_desc, url_entered: @url.url_entered, url_title: @url.url_title,
                                     url_type: @url.url_type } }
    end

    assert_redirected_to url_path(assigns(:url))
  end

  test 'should show url' do
    get :show, params: { id: @url }
    assert_response :success
  end

  test 'should get edit' do
    get :edit, params: { id: @url }
    assert_response :success
  end

  test 'should update url' do
    patch :update,
          params: { id: @url,
                    url: { url: @url.url, url_desc: @url.url_desc, url_entered: @url.url_entered, url_title: @url.url_title,
                           url_type: @url.url_type } }
    assert_redirected_to url_path(assigns(:url))
  end

  test 'should destroy url' do
    assert_difference('Url.count', -1) do
      delete :destroy, params: { id: @url }
    end

    assert_redirected_to urls_path
  end
end
