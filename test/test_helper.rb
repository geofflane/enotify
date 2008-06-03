ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

class Test::Unit::TestCase
  # Transactional fixtures accelerate your tests by wrapping each test method
  # in a transaction that's rolled back on completion.  This ensures that the
  # test database remains unchanged so your fixtures don't have to be reloaded
  # between every test method.  Fewer database queries means faster tests.
  #
  # Read Mike Clark's excellent walkthrough at
  #   http://clarkware.com/cgi/blosxom/2005/10/24#Rails10FastTesting
  #
  # Every Active Record database supports transactions except MyISAM tables
  # in MySQL.  Turn off transactional fixtures in this case; however, if you
  # don't care one way or the other, switching from MyISAM to InnoDB tables
  # is recommended.
  #
  # The only drawback to using transactional fixtures is when you actually 
  # need to test transactions.  Since your test is bracketed by a transaction,
  # any transactions started in your code will be automatically rolled back.
  self.use_transactional_fixtures = true

  # Instantiated fixtures are slow, but give you @david where otherwise you
  # would need people(:david).  If you don't want to migrate your existing
  # test cases which use the @david style and don't mind the speed hit (each
  # instantiated fixtures translates to a database query per test method),
  # then set this back to true.
  self.use_instantiated_fixtures  = false

  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...

  INCIDENT_TEST1 = <<EOS
You have a Milwaukee.Gov E-Notification for the Police Verified Offense Notification category.
 
An incident (#081020141) of Burglary was recorded at 310 E BROWN ST on April 11, 2008 @ 05:49 PM. The final outcome or disposition of this incident was recorded as Filed (Other).
If you have any information regarding this crime you can call the District #1 station at 935-7213.

Please click the link below for information regarding obtaining a Police Report.
http://www.city.milwaukee.gov/display/router.asp?docid=427

Crime data can be viewed on maps by using the City of Milwaukee COMPASS "Community Mapping" application at http://www.city.milwaukee.gov/display/router.asp?docid=13176

 
Neither the City of Milwaukee nor the Milwaukee Police Department guarantee (either express or implied) the accuracy, completeness, timeliness, or correct sequencing of the Crime Data. The City of Milwaukee and the Milwaukee Police Department shall have no liability for any error or omission, or for the use of, or the results obtained from the use of the Crime Data. In addition, the City of Milwaukee and the Milwaukee Police Department caution against using the Crime Data to make decisions/comparisons regarding the safety of or the amount of crime occurring in a particular area.
the information represents only police services where a report was made and does not include other calls for police service
the information does not reflect or certify "safe" or "unsafe" areas
the information will sometimes reflect where the crime was reported versus where the crime occurred 
The use of the Crime Data indicates the site user\'s unconditional acceptance of all risks associated with the use of the Crime Data.
 
Please do not respond to this email. It is not set up to receive emails.

You have received this notification because you subscribed to be notified for the Police Verified Offense Notification category from the City of Milwaukee.

Please use the link to add or to remove categories from your account or delete your account
http://itmdapps.ci.mil.wi.us/login/citizenlogin

EOS
end
