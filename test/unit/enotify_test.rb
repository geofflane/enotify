require 'test_helper'

class EnotifyTest < ActionMailer::TestCase
  tests Enotify
  def test_receive
  
    raw_mail = read_fixture('incident').join
    assert Enotify.receive(raw_mail)

    incident = Incident.find(:first, :joins => :address, :conditions => "addresses.street='2776 N BOOTH ST'")

    assert_not_nil incident
    
    mail = incident.enotify_mail
    
    assert_not_nil mail
    assert mail.success
    assert_not_nil mail.incident
  end

end
