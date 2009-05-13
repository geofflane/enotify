class ServiceRequestsController < IncidentsController
  layout 'default'
  permit "admin", :only => [:new, :edit, :create, :update, :destroy]
end
