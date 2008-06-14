require 'test_helper'

class IncidentsControllerTest < ActionController::TestCase
  def setup
    @request    = ActionController::TestRequest.new
    login_as('quentin')
  end
  
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:incidents)
  end

  def test_should_show_incident
    get :show, :id => incidents(:theft).id
    assert_response :success
  end

end
