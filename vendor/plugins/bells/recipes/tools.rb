namespace :tools do
  
  desc "Copies contents of ssh public keys into authorized_keys file"
  task :setup_ssh_keys do
    sudo "test -d ~/.ssh || mkdir ~/.ssh"
    sudo "chmod 0700 ~/.ssh"    
    put(ssh_options[:keys].collect{|key| File.read(key+'.pub')}.join("\n"),
      File.join('/home', user, '.ssh/authorized_keys'),
      :mode => 0600 )
  end
  
  desc "Displays server uptime"
  task :uptime do
    run "uptime"
  end
  
  desc "Look for necessary commands"
  task :look_for_commands do
    %w(ruby rake svn).each do |command|
      run "which #{command}"
    end
  end
  
  namespace :svn do
    desc "remove and ignore log files and tmp from subversion"
    task :clean do
      logger.info "removing log directory contents from svn"
      system "svn remove log/* --force"
      logger.info "ignoring log directory"
      system "svn propset svn:ignore '*.log' log/"
      system "svn update log/"
      logger.info "ignoring tmp directory"
      system "svn propset svn:ignore '*' tmp/"
      system "svn update tmp/"
      logger.info "committing changes"
      system "svn commit -m 'Removed and ignored log files and tmp'"
    end

    desc "Add new files to subversion"
    task :add do
      logger.info "Adding unknown files to svn"
      system "svn status | grep '^\?' | sed -e 's/? *//' | sed -e 's/ /\ /g' | xargs svn add"
    end
    
    desc "Commits changes to subversion repository"
    task :commit do
      puts "Enter log message:"
      m = $stdin.gets.chomp
      logger.info "Committing changes..."
      system "svn commit -m #{m}"
    end
    
  end
  
  namespace :gems do
    
    task :default do
      puts <<-DESC
        
        Tasks to adminster Ruby Gems on a remote server: \
         \
        cap tools:gems:list \
        cap tools:gems:update \
        cap tools:gems:install \
        cap tools:gems:remove \
        
      DESC
    end
    
    desc "List gems on remote server"
    task :list do
      stream "gem list"
    end
    
    desc "Update gems on remote server"
    task :update do
      sudo "gem update"
    end
    
    desc "Install a gem on the remote server"
    task :install do
      # TODO Figure out how to use Highline with this
      puts "Enter the name of the gem you'd like to install:"
      gem_name = $stdin.gets.chomp
      logger.info "trying to install #{gem_name}"
      sudo "gem install #{gem_name}"
    end
    
    desc "Uninstall a gem from the remote server"
    task :remove do
      puts "Enter the name of the gem you'd like to remove:"
      gem_name = $stdin.gets.chomp
      logger.info "trying to remove #{gem_name}"
      sudo "gem install #{gem_name}"
    end
    
  end
  
end