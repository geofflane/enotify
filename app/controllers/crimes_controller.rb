class CrimesController < IncidentsController
  before_filter :login_required
  layout 'default'

end
