require 'test_helper'

class EnotifyRouterTest < ActiveSupport::TestCase

  def test_routes_to_incident
    route_test('crime', CrimeParser)
  end
  
  def test_routes_to_service_request
    route_test('service', ServiceRequestParser)
  end
  
  def test_routes_to_permit_record
    route_test('permit', PermitRecordParser)
  end
  
  def test_router_parses_incident
    parse_test('crime')
  end
  
  def test_router_parses_service_request
    parse_test('service')
  end
  
  def test_router_parses_permit_record
    parse_test('permit')
  end
    
  private
  def route_test(fixture, clazz)
    raw_mail = read_enotify_fixture(fixture).join
    email = TMail::Mail.parse(raw_mail)
    
    router = EnotifyRouter.new('Milwaukee', 'WI')
    report_builder = router.report_builder_for_mail(email)
    
    assert_not_nil report_builder
    assert_kind_of clazz, report_builder.parser
    assert_equal 'Milwaukee', report_builder.city
    assert_equal 'WI', report_builder.state
  end
  
  def parse_test(fixture)
    raw_mail = read_enotify_fixture(fixture).join
    email = TMail::Mail.parse(raw_mail)
    
    router = EnotifyRouter.new('Milwaukee', 'WI')
    report = router.create_from_mail(email)
    
    assert_not_nil report
    assert_not_nil report.enotify_mail
    assert_not_nil report.address
  end
end
