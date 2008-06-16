require 'test_helper'

class RecordingApplicationsControllerTest < ActionController::TestCase
  def setup
    @request    = ActionController::TestRequest.new
    login_as('quentin')
  end
  
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:recording_applications)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_recording_application
    assert_difference('RecordingApplication.count') do
      post :create, :recording_application => { :record_number => 'recording123' }
    end

    assert_redirected_to recording_application_path(assigns(:recording_application))
  end

  def test_should_show_recording_application
    get :show, :id => incidents(:recording).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => incidents(:recording).id
    assert_response :success
  end

  def test_should_update_recording_application
    put :update, :id => incidents(:recording).id, :recording_application => { }
    assert_redirected_to recording_application_path(assigns(:recording_application))
  end

  def test_should_destroy_recording_application
    assert_difference('RecordingApplication.count', -1) do
      delete :destroy, :id => incidents(:recording).id
    end

    assert_redirected_to recording_applications_path
  end
end
