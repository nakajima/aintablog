# Set these variables to reflect the location of apachectl

# TODO Create installation tasks

namespace :deploy do
  namespace :apache do
  
    desc "Restarts Apache webserver"
    task :restart do
      sudo "#{apache_ctl} restart"
    end
  
    desc "Starts Apache webserver"
    task :start do
      sudo "#{apache_ctl} start"
    end
  
    desc "Stops Apache webserver"
    task :stop do
      sudo "#{apache_ctl} stop"
    end
    
    desc "Reload Apache webserver"
    task :reload_apache do
      sudo "#{apache_ctl} reload"
    end
    
    desc "Configure virtual server on remote app."
    task :setup do
      logger.info "generating .conf file"
      conf = <<-CONF  
<VirtualHost *:80>
  ServerName #{domain}

    ServerAlias www.#{domain}

  DocumentRoot #{deploy_to}/current/public

  <Directory #{deploy_to}/current/public>
    Options FollowSymLinks
    AllowOverride None
    Order allow,deny
    Allow from all
  </Directory>

  # Configure mongrel_cluster 
  <Proxy balancer://#{application}_cluster>

  BalancerMember http://#{mongrel_address}:#{mongrel_port}

  </Proxy>

  RewriteEngine On

  # Prevent access to .svn directories
  RewriteRule ^(.*/)?\.svn/ - [F,L]
  ErrorDocument 403 "Access Forbidden"

  # Check for maintenance file and redirect all requests
  RewriteCond %{DOCUMENT_ROOT}/system/maintenance.html -f
  RewriteCond %{SCRIPT_FILENAME} !maintenance.html
  RewriteRule ^.*$ /system/maintenance.html [L]

  # Rewrite index to check for static
  RewriteRule ^/$ /index.html [QSA] 

  # Rewrite to check for Rails cached page
  RewriteRule ^([^.]+)$ $1.html [QSA]

  # Redirect all non-static requests to cluster
  RewriteCond %{DOCUMENT_ROOT}/%{REQUEST_FILENAME} !-f
  RewriteRule ^/(.*)$ balancer://#{application}_cluster%{REQUEST_URI} [P,QSA,L]

  # Deflate
  AddOutputFilterByType DEFLATE text/html text/plain text/xml
  BrowserMatch ^Mozilla/4 gzip-only-text/html
  BrowserMatch ^Mozilla/4\.0[678] no-gzip
  BrowserMatch \bMSIE !no-gzip !gzip-only-text/html

  ErrorLog logs/#{domain}-error_log
  CustomLog logs/#{domain}-access_log combined
</VirtualHost>
      CONF
      
      require 'erb'
      result = ERB.new(conf).result(binding)
      put result, "#{application}.conf"
      logger.info "placing #{application}.conf on remote server"
      sudo "mv #{application}.conf #{apache_conf}"
      sudo "chown deploy:users #{apache_conf}"
      sudo "chmod 775 #{apache_conf}"
    end
  end
end

namespace :local do
  namespace :apache do
    desc "Start apache on local machine"
    task :start do
      puts "Starting Apache..."
      system "sudo #{local_apache_ctl_path} start"
    end
  
    desc "Stop apache on local machine"
    task :stop do
      puts "Stopping Apache..."
      system "sudo #{local_apache_ctl_path} stop"
    end
  
    desc "Restart apache on local machine"
    task :restart do
      puts "Restarting Apache..."
      system "sudo #{local_apache_ctl_path} restart"
    end
  end
end
