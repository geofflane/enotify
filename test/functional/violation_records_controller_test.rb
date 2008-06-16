require 'test_helper'

class ViolationRecordsControllerTest < ActionController::TestCase
  def setup
    @request    = ActionController::TestRequest.new
    login_as('quentin')
  end
  
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:violation_records)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_violation_record
    assert_difference('ViolationRecord.count') do
      post :create, :violation_record => { :record_number => 'violation123' }
    end

    assert_redirected_to violation_record_path(assigns(:violation_record))
  end

  def test_should_show_violation_record
    get :show, :id => incidents(:violation).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => incidents(:violation).id
    assert_response :success
  end

  def test_should_update_violation_record
    put :update, :id => incidents(:violation).id, :violation_record => { }
    assert_redirected_to violation_record_path(assigns(:violation_record))
  end

  def test_should_destroy_violation_record
    assert_difference('ViolationRecord.count', -1) do
      delete :destroy, :id => incidents(:violation).id
    end

    assert_redirected_to violation_records_path
  end
end
