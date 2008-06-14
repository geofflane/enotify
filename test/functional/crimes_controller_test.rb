require 'test_helper'

class CrimesControllerTest < ActionController::TestCase
  def setup
    @request    = ActionController::TestRequest.new
    login_as('quentin')
  end
  
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:crimes)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_crime
    assert_difference('Crime.count') do
      post :create, :crime => { }
    end

    assert_redirected_to crime_path(assigns(:crime))
  end

  def test_should_show_crime
    get :show, :id => incidents(:theft).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => incidents(:theft).id
    assert_response :success
  end

  def test_should_update_crime
    put :update, :id => incidents(:theft).id, :crime => { }
    assert_redirected_to crime_path(assigns(:crime))
  end

  def test_should_destroy_crime
    assert_difference('Crime.count', -1) do
      delete :destroy, :id => incidents(:theft).id
    end

    assert_redirected_to crimes_path
  end
end
