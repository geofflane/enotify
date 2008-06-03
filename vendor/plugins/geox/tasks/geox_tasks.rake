namespace :geox do
  desc 'Test the simple_geocoder plugin.'
  Rake::TestTask.new(:test) do |t|
    t.pattern = "#{RAILS_ROOT}/vendor/plugins/geox/test/**/*_test.rb"
    t.verbose = true
  end
end # namespace :geox

#  desc "Task for geox"
#  task :task_here do
#
#  end
#end