# Ensure that bundle is used for rake tasks
SSHKit.config.command_map[:rake] = "bundle exec rake"

# config valid only for Capistrano 3.1
set :application, 'starter_package'
set :stages, ["production"]
set :use_sudo, false
set :deploy_user, 'deploy'
set :deploy_user_group, 'deployers'

# Default value for :scm is :git
set :scm, :git
set :repo_url, ''
set :deploy_via, :remote_cache

set :linked_dirs, fetch(:linked_dirs, []).push('tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system',)
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

desc 'Invoke a rake command on the remote server'
task :invoke, [:command] => 'deploy:set_rails_env' do |task, args|
  on primary(:app) do
    within current_path do
      with :rails_env => fetch(:rails_env) do
        rake args[:command]
      end
    end
  end
end

namespace :deploy do
  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute "chgrp -R deployers #{release_path}; exit 0"
          execute "chmod -R 755 #{release_path}; exit 0"
          execute :rake, 'tmp:cache:clear'
        end
      end
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 10 do
      execute "chgrp -R deployers #{release_path}; exit 0"
      execute "chmod -R 755 #{release_path}; exit 0"

      # Restarts Phusion Passenger
      if fetch(:deployment_server) == :passenger
        execute "passenger-config restart-app /"
        #execute :touch, release_path.join('tmp/restart.txt')
      end
    end
  end
end
