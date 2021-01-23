# frozen_string_literal: true

# config valid for current version and patch releases of Capistrano
lock '~> 3.15.0'

set :application, 'invest_plan'
set :repo_url, 'git@github.com:asaytechnologies/investor_day_book.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/var/www/html/invest_plan'
set :deploy_user, 'deploy'

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml"
set :linked_files, fetch(:linked_files, []).push('config/master.key', 'config/production.sphinx.conf')

# rubocop: disable Layout/LineLength
# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'storage', 'db/sphinx', 'tmp/binlog')
# rubocop: enable Layout/LineLength

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart
end

namespace :yarn do
  desc 'Yarn'
  task :install do
    on roles(:app) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, 'exec yarn install'
        end
      end
    end
  end
end

namespace :sphinx do
  desc 'Start sphinx'
  task :start do
    on roles(:app) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, 'exec rails ts:start'
        end
      end
    end
  end

  desc 'Rebuild sphinx'
  task :rebuild do
    on roles(:app) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, 'exec rails ts:rebuild'
        end
      end
    end
  end

  desc 'Configure sphinx'
  task :configure do
    on roles(:app) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, 'exec rails ts:configure'
        end
      end
    end
  end
end

namespace :que do
  desc 'Start que worker'
  task :start do
    on roles(:app) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, 'exec que ./config/environment.rb'
        end
      end
    end
  end

  desc 'Stop que worker'
  task :stop do
    on roles(:app) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute "ps aux | grep '[b]in/que' | awk '{ print $2 }' | xargs kill"
        end
      end
    end
  end
end

after 'bundler:install', 'yarn:install'
after 'deploy:published', 'bundler:clean'
# sphinx:start need only after server reboot
# after 'deploy:restart', 'sphinx:start'
after 'deploy:restart', 'sphinx:rebuild'
# que:stop don't need after server restart
after 'sphinx:rebuild', 'que:start'
# after 'que:stop', 'que:start'
