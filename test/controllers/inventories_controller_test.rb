require 'test_helper'

class InventoriesControllerTest < ActionController::TestCase
  setup do
    http_login(:user)
    @inventory = inventories(:carpet)
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:inventories)
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create inventory' do
    assert_difference('Inventory.count') do
      post :create, inventory: {
        store: @inventory.store,
        code:  @inventory.code,
        roll:  'abcdefg',
        width: @inventory.width,
        feet:  @inventory.feet
      }
    end
    assert_redirected_to inventories_path
  end

  test 'should show inventory' do
    get :show, id: @inventory
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @inventory
    assert_response :success
  end

  test 'should update inventory' do
    patch :update, id: @inventory, inventory: {
      store: @inventory.store,
      code: @inventory.code,
      roll: @inventory.roll,
      width: @inventory.width,
      feet: @inventory.feet
    }
    assert_redirected_to inventories_path
  end

  test 'should destroy inventory' do
    assert_difference('Inventory.count', -1) do
      delete :destroy, id: @inventory
    end

    assert_redirected_to inventories_path
  end
end
