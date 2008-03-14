# Recipe adapted from deprec gem

namespace :deploy do

  namespace :mongrel do
    desc <<-DESC
    Configure Mongrel processes on the app server. This uses the :use_sudo
    variable to determine whether to use sudo or not. By default, :use_sudo is
    set to true.
    DESC
    task :configure, :roles => :app do
      set_mongrel_conf
      
      argv = []
      argv << "mongrel_rails cluster::configure"
      argv << "-N #{mongrel_servers.to_s}"
      argv << "-p #{mongrel_port.to_s}"
      argv << "-e #{mongrel_environment}"
      argv << "-a #{mongrel_address}"
      argv << "-c #{current_path}"
      argv << "-C #{mongrel_conf}"
      cmd = argv.join " "
      sudo cmd
    end

    desc <<-DESC
    Start Mongrel processes on the app server.  This uses the :use_sudo variable to determine whether to use sudo or not. By default, :use_sudo is
    set to true.
    DESC
    task :start , :roles => :app do
      set_mongrel_conf
      run "mongrel_rails cluster::start -C #{mongrel_conf}"
    end

    desc <<-DESC
    Restart the Mongrel processes on the app server by starting and stopping the cluster. This uses the :use_sudo
    variable to determine whether to use sudo or not. By default, :use_sudo is set to true.
    DESC
    task :restart , :roles => :app do
      set_mongrel_conf
      run "mongrel_rails cluster::restart -C #{mongrel_conf}"
    end

    desc <<-DESC
    Stop the Mongrel processes on the app server.  This uses the :use_sudo
    variable to determine whether to use sudo or not. By default, :use_sudo is
    set to true.
    DESC
    task :stop , :roles => :app do
      set_mongrel_conf
      run "mongrel_rails cluster::stop -C #{mongrel_conf}"
    end

    def set_mongrel_conf
      set :mongrel_conf, "/etc/mongrel_cluster/#{application}.yml" unless mongrel_conf
    end
  end
end