# frozen_string_literal: true

require 'test_helper'

class MediaownersControllerTest < ActionController::TestCase
  before do
    @mediaowner = mediaowners(:one)
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:mediaowners)
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create mediaowner' do
    assert_difference('Mediaowner.count') do
      post :create, params: { mediaowner: { content_frequency_guide: @mediaowner.content_frequency_guide,
                                            content_frequency_other: @mediaowner.content_frequency_other, content_frequency_time: @mediaowner.content_frequency_time, distribution_type: @mediaowner.distribution_type, media_type: @mediaowner.media_type, nextissue_yn: @mediaowner.nextissue_yn, owner_name: @mediaowner.owner_name, paywall_yn: @mediaowner.paywall_yn, publication_name: @mediaowner.publication_name, story_id: @mediaowner.story_id, title: @mediaowner.title, url: @mediaowner.url, url_domain: @mediaowner.url_domain } }
    end

    assert_redirected_to mediaowner_path(assigns(:mediaowner))
  end

  test 'should show mediaowner' do
    get :show, params: { id: @mediaowner }
    assert_response :success
  end

  test 'should get edit' do
    get :edit, params: { id: @mediaowner }
    assert_response :success
  end

  test 'should update mediaowner' do
    patch :update,
          params: { id: @mediaowner,
                    mediaowner: { content_frequency_guide: @mediaowner.content_frequency_guide,
                                  content_frequency_other: @mediaowner.content_frequency_other, content_frequency_time: @mediaowner.content_frequency_time, distribution_type: @mediaowner.distribution_type, media_type: @mediaowner.media_type, nextissue_yn: @mediaowner.nextissue_yn, owner_name: @mediaowner.owner_name, paywall_yn: @mediaowner.paywall_yn, publication_name: @mediaowner.publication_name, story_id: @mediaowner.story_id, title: @mediaowner.title, url: @mediaowner.url, url_domain: @mediaowner.url_domain } }
    assert_redirected_to mediaowner_path(assigns(:mediaowner))
  end

  test 'should destroy mediaowner' do
    assert_difference('Mediaowner.count', -1) do
      delete :destroy, params: { id: @mediaowner }
    end

    assert_redirected_to mediaowners_path
  end
end
