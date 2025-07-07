# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative "config/application"
require 'resque/tasks'

task "resque:setup" => :environment #do
#   Grit::Git.git_timeout = 10.minutes
# end
Rails.application.load_tasks
