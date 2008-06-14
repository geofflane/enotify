set :application, "enotify"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/var/www/enotify"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
default_run_options[:pty] = true
set :scm, :git
set :repository, "geoff@zorched.net:enotify.git"
set :branch, "master"
set :deploy_via, :remote_cache
set :ssh_options, { :forward_agent => true }

role :app, "zorched.net"
role :web, "zorched.net"
role :db,  "zorched.net", :primary => true

