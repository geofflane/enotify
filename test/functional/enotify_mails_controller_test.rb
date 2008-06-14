require 'test_helper'

class EnotifyMailsControllerTest < ActionController::TestCase
  
  def setup
    @request    = ActionController::TestRequest.new
    login_as('quentin')
  end
  
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:enotify_mails)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_enotify_mail
    assert_difference('EnotifyMail.count') do
      mail = read_enotify_fixture('crime').join
      post :create, :enotify_mail => { :original_text => mail }
    end

    assert_redirected_to enotify_mail_path(assigns(:enotify_mail))
  end

  def test_should_show_enotify_mail
    get :show, :id => enotify_mails(:crime_incident).id
    assert_response :success
  end

  def test_should_destroy_enotify_mail
    assert_difference('EnotifyMail.count', -1) do
      delete :destroy, :id => enotify_mails(:crime_incident).id
    end

    assert_redirected_to enotify_mails_path
  end
end
