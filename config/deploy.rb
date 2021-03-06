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

namespace :deploy do

  namespace :assets do
    desc 'Pre-compile assets'
    task :precompile do
      on roles(:web) do
        within release_path do
          with rails_env: fetch(:rails_env) do
            execute :rake, 'assets:precompile'
          end
        end
      end
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      execute :mkdir, "-p #{release_path.join('tmp')}"
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  desc 'Write the current version to public/version.txt'
  task :write_version do
    on roles(:app), in: :sequence do
      within repo_path do
        execute :echo, "`git describe --all --always --long --abbrev=40 HEAD` `date +\"%Y-%m-%d %H:%M:%S %Z\"` #{ENV['CODENAME']} > #{release_path}/public/version.txt"
      end
    end
  end

  after :finishing, 'deploy:write_version'
  after :finishing, 'deploy:assets:precompile'
  after :finishing, 'deploy:cleanup'
  after :finishing, 'deploy:restart'

end
