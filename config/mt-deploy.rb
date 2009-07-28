load "deploy"

set :application, "map"
set :site, "61600"
set :webpath, "nwscdc.org/html/community/map"
set :domain, "nwscdc.com"
set :user, "serveradmin%nwscdc.com"
set :password, "SYnqfEPu"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/home/61600/containers/map"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
default_run_options[:pty] = true
set :scm, :git
set :repository, "geoff@zorched.net:enotify.git"
set :branch, "master"
set :deploy_via, :remote_cache

set :ssh_options, { :forward_agent => true, :password => true }

role :app, "#{domain}"
role :web, "#{domain}"
role :db,  "#{domain}", :primary => true

before "deploy:start" do 
  run "#{current_path}/script/ferret_server -e production start"
end 

after "deploy:stop" do 
  run "#{current_path}/script/ferret_server -e production stop"
end

after 'deploy:restart' do
  run "cd #{current_path} && ./script/ferret_server -e production stop"
  run "cd #{current_path} && ./script/ferret_server -e production start"
end

namespace :deploy do
  desc "Restarting rails app on mediatemple using mtr"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "mtr restart #{application} -u #{user} -p #{password}"
    run "mtr generate_htaccess #{application} -u #{user} -p #{password}"
    migrate
  end
end
