# config valid for current version and patch releases of Capistrano
set :application, "hifive"
set :repo_url, "https://github.com/ucsdlib/hifive.git"

set :deploy_to, '/pub/highfive'

# rails
# rails migrations are related to the framework/app
set :migration_role, :app
# Skip migration if files in db/migrate were not modified
set :conditionally_migrate, true

# rbenv
set :rbenv_type, :user
set :rbenv_ruby, File.read('.ruby-version').strip
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all # default value
