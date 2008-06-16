class RecordingAppParserTest < ActiveSupport::TestCase

  def test_recording_application_parsed_into_good_values
    sp = RecordingAppParser.new
    permit_rec = sp.parse(RECORDING_APP_TEST1, 'Milwaukee', 'WI')
    assert_equal 'Milwaukee', permit_rec.address.city
    assert_equal 'WI', permit_rec.address.state
    assert_equal '2828 N FRATNEY ST', permit_rec.address.street
    assert_equal '#135371', permit_rec.record_number
    assert_equal '314-0135-000', permit_rec.tax_key
  end

end
