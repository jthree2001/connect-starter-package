SSHKit.config.command_map[:rake] = "bundle exec rake"

# config valid only for Capistrano 3.1
set :stages, ["production","staging"]
set :use_sudo, false
set :deploy_user, 'deploy'
set :deploy_user_group, 'deployers'

set :repo_url, 'ssh://git@intranet.zuora.com:7999/rbm/connectstarter.git'
set :deploy_via, :remote_cache
set :keep_releases, 2

set :linked_dirs, fetch(:linked_dirs, []).push('tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system',)
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# ROLES=worker cap production "invoke[resque:stop]"
desc 'Invoke a rake command on the remote server EXAMPLE: '
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
  task :clear_cache do
    on roles(:app) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'tmp:cache:clear'
        end
      end
    end
  end

  desc 'File application'
  task :mod_files do
    on roles(:app) do
      within release_path do
        execute "chgrp -R deployers #{release_path}; exit 0"
        execute "chmod -R 755 #{release_path}; exit 0"
      end
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :groups, limit: 1, wait: 1 do
      execute "/etc/init.d/unicorn upgrade"
    end
  end

  desc "Clear Concurrant"
  task :clear_concurrant do
    on roles(:worker), in: :sequence, wait: 1 do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'resque:delete_concurrent'
        end
      end
    end
  end

  task :restart_workers do
    desc "Restart Delayed Job Workers"
    on roles(:worker),in: :sequence, wait: 5 do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute "RAILS_ENV=#{fetch :rails_env} #{release_path}/bin/delayed_job -n 2 restart"
        end
      end
    end
  end

  before 'deploy:symlink:release', :mod_files
  after :publishing, :restart
  after :restart, :clear_cache
  after :restart, :restart_workers
end
