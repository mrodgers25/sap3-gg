require 'test_helper'

class StoriesControllerTest < ActionController::TestCase
  before do
    @story = stories(:one)
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:stories)
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create story' do
    assert_difference('Story.count') do
      post :create, params: { story: { author: @story.author, media_id: @story.media_id, publication_date: @story.publication_date,
                                       story_type: @story.story_type, url_id: @story.url_id } }
    end

    assert_redirected_to story_path(assigns(:story))
  end

  test 'should show story' do
    get :show, params: { id: @story }
    assert_response :success
  end

  test 'should get edit' do
    get :edit, params: { id: @story }
    assert_response :success
  end

  test 'should update story' do
    patch :update,
          params: { id: @story,
                    story: { author: @story.author, media_id: @story.media_id, publication_date: @story.publication_date,
                             story_type: @story.story_type, url_id: @story.url_id } }
    assert_redirected_to story_path(assigns(:story))
  end

  test 'should destroy story' do
    assert_difference('Story.count', -1) do
      delete :destroy, params: { id: @story }
    end

    assert_redirected_to stories_path
  end
end
