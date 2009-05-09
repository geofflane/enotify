class ViolationRecordParserTest < ActiveSupport::TestCase

  def test_violation_record_parsed_into_good_values
    sp = ViolationRecordParser.new
    permit_rec = sp.parse(VIOLATION_RECORD_TEST1, 'Milwaukee', 'WI')
    assert_equal 'Milwaukee', permit_rec.address.city
    assert_equal 'WI', permit_rec.address.state
    assert_equal '507 E CHAMBERS ST', permit_rec.address.street
    assert_equal '6858061', permit_rec.record_number
    assert_equal 'Remove and dispose of all debris, junk, etc.', permit_rec.description
    assert_equal '314-0945-000', permit_rec.tax_key
  end

end
