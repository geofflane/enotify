class PermitRecordParserTest < ActiveSupport::TestCase

  def test_service_request_parsed_into_good_values
    sp = PermitRecordParser.new
    permit_rec = sp.parse(PERMIT_RECORD_TEST1, 'Milwaukee', 'WI')
    assert_equal 'Milwaukee', permit_rec.address.city
    assert_equal 'WI', permit_rec.address.state
    assert_equal '2551 N DOUSMAN ST', permit_rec.address.street
    assert_equal '#789636', permit_rec.record_number
    assert_equal 'Electrical-Alteration', permit_rec.description
    assert_equal '320-0211-000', permit_rec.tax_key
  end

end
