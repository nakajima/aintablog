namespace :deploy do
  namespace :db do
    desc "Create db"
    task :create do
      run "cd #{current_path} && RAILS_ENV=#{mongrel_environment} rake db:create"
    end
  end

  task :restart do
    thin.restart
  end
  
  task :start do
    thin.start
  end
  
  task :stop do
    thin.stop
  end

  desc "Shows tail of production log"
  task :tail do
    stream "tail -f #{current_path}/log/production.log"
  end
  
  desc "Clobber mongrel log"
  task :clobber_mongrel do
    logger.info "removing mongrel log..."
    run "rm #{current_path}/log/mongrel.8821.log"
    logger.info "done!"
  end
  
  after "deploy:update_code", "deploy:copy_config_files"
  desc "Copy production database.yml to live app"
  task :copy_config_files do
    config_files.each do |file|
      run "cp #{shared_path}/config/#{file} #{release_path}/config/"
    end
  end

end