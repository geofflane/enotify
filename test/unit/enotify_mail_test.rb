require 'test_helper'

class EnotifyMailTest < ActiveSupport::TestCase
  
  def test_parsing_of_raw_mail
    
    reports = CityReports.new(IncidentParser.new, GeoLocationLookup.new, 'Milwaukee', 'WI')
    
    raw_mail = read_enotify_fixture('incident').join
    mail = EnotifyMail.create_from_raw_mail(reports, raw_mail)

    assert_not_nil mail
    assert_not_nil mail.incident
    assert mail.success
    assert_equal 'Locked Vehicle Entry', mail.incident.description
    assert_equal 'Referred/Closed', mail.incident.resolution
    
    assert_equal '2776 N BOOTH ST', mail.incident.address.street
    assert_equal 'Milwaukee', mail.incident.address.city
    
  end
end
