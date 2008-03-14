namespace :deploy do
  namespace :db do
    desc "Runs rake db:create on remote server"
    task :create do
      run "cd #{current_path} && RAILS_ENV=#{mongrel_environment} rake db:create"
    end
  end

  task :restart do
    run "mongrel_rails cluster::restart -C #{mongrel_conf}" 
  end
  
  task :start do
    run "mongrel_rails cluster::start -C #{mongrel_conf}" 
  end
  
  task :stop do
    run "mongrel_rails cluster::stop -C #{mongrel_conf}" 
  end

  desc "Shows tail of production log"
  task :tail do
    stream "tail -f #{current_path}/log/production.log"
  end
  
  desc "Show tail of mongrel log"
  task :tail_mongrel do
    stream "tail -f #{current_path}/log/mongrel.log"
  end

  # after "deploy:update_code", "deploy:copy_config_files"
  desc "Copy production database.yml to live app"
  task :copy_config_files do
    config_files.each do |file|
      run "cp #{shared_path}/config/#{file} #{release_path}/config/"
    end
  end
  
  desc "Nuke and rebuild production db"
  task :reset_db do
    puts 'Are you sure? This action is unreversible. You will lose data.'
    print 'Do you still wish to reset the db? [y/n] '
    result = $stdin.gets.chomp
    if result[0..0].match(/y/i)
      puts 'clearing db...'
      run "cd #{current_path} && RAILS_ENV='production' rake db:migrate VERSION=0"
      puts 'rebuilding db...'
      run "cd #{current_path} && RAILS_ENV='production' rake db:migrate"
      puts 'loading admin...'
      run "cd #{current_path} && RAILS_ENV='production' rake utils:load_admin"
      puts 'all done!'
    else
      puts 'action canceled'
    end
  end

end