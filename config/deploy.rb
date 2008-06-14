set :application, "enotify"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/var/www/enotify"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
set :scm, :git
set :repository, "geoff@zorched.net:/home/geoff/enotify"

role :app, "enotify.zorched.net"
role :web, "enotify.zorched.net"
role :db,  "enotify.zorched.net", :primary => true

