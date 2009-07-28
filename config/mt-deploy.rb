require "mt-capistrano"

set :site,         "61600"
set :application,  "map"
set :webpath,      "nwscdc.org/html/community/map"
set :domain,       "nwscdc.org"
set :user,         "serveradmin@nwscdc.org"
set :password,     "SYnqfEPu"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
default_run_options[:pty] = true
set :scm, :git
set :repository, "geoff@zorched.net:enotify.git"
set :branch, "master"
set :deploy_via, :remote_cache

set :ssh_options, { :forward_agent => true, :password => true }

# which environment to work in
set :rails_env,    "production"

# necessary for functioning on the (gs)
default_run_options[:pty] = true

# these shouldn't be changed
role :web, "#{domain}"
role :app, "#{domain}"
role :db,  "#{domain}", :primary => true
set :deploy_to,    "/home/#{site}/containers/rails/#{application}"

# uncomment if desired
#after "deploy:update_code".to_sym do
#  put File.read("deploy/database.yml.mt"), "#{release_path}/config/database.yml", :mode => 0444
#end

# update .htaccess rules after new version is deployed
after "deploy:symlink".to_sym, "mt:generate_htaccess".to_sym
