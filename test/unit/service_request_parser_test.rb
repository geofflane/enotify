class ServiceRequestParserTest < ActiveSupport::TestCase

  def test_service_request_parsed_into_good_values
    sp = ServiceRequestParser.new
    service_req = sp.parse(SERVICE_REQUEST_TEST1, 'Milwaukee', 'WI')
    assert_equal 'Milwaukee', service_req.address.city
    assert_equal 'WI', service_req.address.state
    assert_equal '2942 N 2ND ST', service_req.address.street
    assert_equal '#475198', service_req.record_number
    assert_equal 'CITATION #NS06583201 WAS LITIGATED AND NOT COMPLIED WITH. FINED $545.00, WARRANT.', service_req.complaint
    assert_equal '313-0528-000', service_req.tax_key
  end

end
