require 'test_helper'

class AmazonKeysControllerTest < ActionController::TestCase
  setup do
    @amazon_key = amazon_keys(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:amazon_keys)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create amazon_key" do
    assert_difference('AmazonKey.count') do
      post :create, amazon_key: @amazon_key.attributes
    end

    assert_redirected_to amazon_key_path(assigns(:amazon_key))
  end

  test "should show amazon_key" do
    get :show, id: @amazon_key
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @amazon_key
    assert_response :success
  end

  test "should update amazon_key" do
    put :update, id: @amazon_key, amazon_key: @amazon_key.attributes
    assert_redirected_to amazon_key_path(assigns(:amazon_key))
  end

  test "should destroy amazon_key" do
    assert_difference('AmazonKey.count', -1) do
      delete :destroy, id: @amazon_key
    end

    assert_redirected_to amazon_keys_path
  end
end
