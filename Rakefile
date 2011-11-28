require 'initialiser'

namespace :dj do

  desc "Start DelayedJob worker"
  task :work do
Delayed::Worker.backend = :active_record
    Delayed::Worker.new.start
  end
end