ActionController::Routing::Routes.draw do |map|
  map.resource :session
    
	map.resources :users, :member => { :suspend   => :put,
                                     :unsuspend => :put,
                                     :purge     => :delete }

  map.resources :crimes, :collection => {:recent => :get}
  
  map.resources :service_requests, :collection => {:recent => :get}

  map.resources :permit_records, :collection => {:recent => :get}

  map.resources :violation_records, :collection => {:recent => :get}

  map.resources :recording_applications, :collection => {:recent => :get}

  map.resources :incidents, :collection => {:recent => :get}

  map.resources :enotify_mails

  map.connect ':controller/:year/:month', 
    :action => 'index',
    :requirements => {:month => /\d{1,2}/, :year => /\d{4}/}
  map.connect ':controller/:year/:month.:format', 
    :action => 'index',
    :requirements => {:month => /\d{1,2}/, :year => /\d{4}/}
    
  map.connect ':controller/search/*terms', :action => 'search'
  map.connect ':controller/search/*terms.:format', :action => 'search'
  
  map.same_block ':controller/same_block/:address_id', :action => 'same_block'
  map.same_block ':controller/same_block/:address_id.:format', :action => 'same_block'
  
  map.by_address ':controller/by_address/:address_id', :action => 'by_address'
  map.by_address ':controller/by_address/:address_id.:format', :action => 'by_address'
  
  map.by_record_number ':controller/by_record_number/:record_number', :action => 'by_record'
  map.by_record_number ':controller/by_record_number/:record_number.:format', :action => 'by_record'
  
  map.by_date ':controller/by_date/:year', :action => 'by_date'
  map.by_date ':controller/by_date/:year.:format', :action => 'by_date'
  map.by_date ':controller/by_date/:year/:month', :action => 'by_date'
  map.by_date ':controller/by_date/:year/:month.:format', :action => 'by_date'
    
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate'
  map.forgot_password '/forgot_password', :controller => 'users', :action => 'forgot_password'
  map.reset_password '/reset_password', :controller => 'users', :action => 'reset_password'
  
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
