# see https://github.com/sul-dlss/sul_pub/wiki/Servers-Deployment-environment
set :application, 'ksr-search'
set :repo_url, "git@github.com:sul-dlss/ksr-app.git"
set :ssh_options,   keys: [Capistrano::OneTimeKey.temporary_ssh_private_key_path],
                    forward_agent: true,
                    auth_methods: %w(publickey password)

set :deploy_to, "/opt/app/ksr/#{fetch(:application)}"

# Default branch is :main
ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push(
#   #'config/database.yml',
# )

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push(
  'log',
  'tmp/pids',
  'tmp/cache',
  'tmp/sockets',
  'vendor/bundle',
  'public/system',
  'config/settings'
)

# UNCOMMENT IF WE USE HONEYBADGER
# honeybadger_env otherwise defaults to rails_env
# we want prod rather than production
# set :honeybadger_env, fetch(:stage)

before 'deploy:restart', 'shared_configs:update'
