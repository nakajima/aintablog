namespace :thin do
  desc "Configure a new cluster"
  task :config, :roles => :app do
    argv = []
    argv << "thin config"
    argv << "-s #{thin_servers.to_s}"
    argv << "-p #{thin_port.to_s}"
    argv << "-e #{thin_environment}"
    argv << "-a #{thin_address}"
    argv << "-c #{current_path}"
    argv << "-C #{thin_conf}"
    cmd = argv.join " "
    sudo cmd
  end
  
  desc "Start thin servers"
  task :start do
    run "thin start -C #{thin_conf}"
  end
  
  desc "Stop thin servers"
  task :stop do
    run "thin stop -C #{thin_conf}"
  end
  
  desc "Restart thin servers"
  task :restart do
    run "thin restart -C #{thin_conf}"
  end
end