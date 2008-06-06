require 'test_helper'

class PermitRecordsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:permit_records)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_permit_record
    assert_difference('PermitRecord.count') do
      post :create, :permit_record => { }
    end

    assert_redirected_to permit_record_path(assigns(:permit_record))
  end

  def test_should_show_permit_record
    get :show, :id => permit_records(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => permit_records(:one).id
    assert_response :success
  end

  def test_should_update_permit_record
    put :update, :id => permit_records(:one).id, :permit_record => { }
    assert_redirected_to permit_record_path(assigns(:permit_record))
  end

  def test_should_destroy_permit_record
    assert_difference('PermitRecord.count', -1) do
      delete :destroy, :id => permit_records(:one).id
    end

    assert_redirected_to permit_records_path
  end
end
