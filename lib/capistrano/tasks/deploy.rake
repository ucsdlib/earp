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

  desc 'Install Ruby if not already installed'
  task :install_latest_ruby do
    on roles(:web) do
      within repo_path do
        unless fetch(:rbenv_ruby) == capture(:ruby, '--version')
          execute "rbenv install #{fetch(:rbenv_ruby)}"
        end
      end
    end
  end
  after :updating,  'deploy:install_latest_ruby'
  after :finishing, 'deploy:write_version'
  after :finishing, 'deploy:assets:precompile'
  after :finishing, 'deploy:cleanup'
  after :finishing, 'deploy:restart'
end
