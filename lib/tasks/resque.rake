require 'resque/tasks'
require 'resque/scheduler/tasks'

task 'resque:preload' => :environment

namespace :resque do
  # https://stackoverflow.com/questions/51757169/how-do-you-schedule-resque-jobs-on-heroku
  # https://grosser.it/2012/04/14/resque-scheduler-on-heroku-without-extra-workers/
  desc 'schedule and work, so we only need 1 dyno'
  task :schedule_and_work do
    if Process.respond_to?(:fork)
      if Process.fork
        sh('rake environment resque:work')
      else
        sh('rake environment resque:scheduler')
        Process.wait
      end
    else # windows
      pid = Process.spawn 'rake environment resque:work'
      Rake::Task['environment resque:scheduler'].invoke
      Process.wait(pid)
    end
  end

  task :setup do
    require 'resque'
  end

  task setup_schedule: :setup do
    require 'resque-scheduler'
  end

  task scheduler: :setup_schedule
end
