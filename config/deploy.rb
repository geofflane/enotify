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

set :user, 'geoff'
set :ssh_options, { :forward_agent => true }

role :app, "zorched.net"
role :web, "zorched.net"
role :db,  "zorched.net", :primary => true

before "deploy:start" do 
  run "#{current_path}/script/ferret_server -e production start"
end 

after "deploy:stop" do 
  run "#{current_path}/script/ferret_server -e production stop"
end

after 'deploy:restart' do
  run "ruby #{current_path}/script/ferret_server -e production stop"
  run "ruby #{current_path}/script/ferret_server -e production start"
end

namespace :deploy do
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end

  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
end
