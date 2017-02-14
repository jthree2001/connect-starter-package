# set path to the application
root = File.expand_path("../../..", __FILE__)
app_dir = "#{root}/current"
shared_dir = "#{root}/shared"
working_directory "#{app_dir}"

# Set unicorn options
worker_processes 4
preload_app true
timeout 30

# Path for the Unicorn socket
listen "#{shared_dir}/tmp/sockets/unicorn.sock", :backlog => 64

# Set path for logging
stderr_path "#{app_dir}/log/unicorn.stderr.log"
stdout_path "#{app_dir}/log/unicorn.stdout.log"

# Set proccess id path
pid "#{shared_dir}/tmp/pids/unicorn.pid"

GC.respond_to?(:copy_on_write_friendly=) &&
  GC.copy_on_write_friendly = true

before_exec do |_server|
  ENV['BUNDLE_GEMFILE'] = "#{app_dir}/Gemfile"
end

# If using ActiveRecord, disconnect (from the database) before forking.
before_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
  end

  if defined?(Resque)
    Resque.redis.quit
  end
end

# After forking, restore your ActiveRecord connection.
after_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  end

  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
  end

  if defined?(Resque)
    Resque.redis = Rails.application.secrets.redis
  end
end
