namespace :deploy do
  namespace :nginx do
    desc "Configure an nginx vhost for this application"
    task :configure do
      template = File.read(File.dirname(__FILE__) + "/templates/nginx.vhost.conf.erb")
      result = ERB.new(template).result(binding)
      put result, "/tmp/#{application}.vhost.conf"
      sudo "mkdir -p #{nginx_sites_available}"
      sudo "mkdir -p #{nginx_sites_enabled}"
      sudo "cp /tmp/#{application}.vhost.conf #{nginx_sites_available}/#{application}.conf"
      sudo "ln -s #{nginx_sites_available}/#{application}.conf #{nginx_sites_enabled}/#{application}.conf"
    end
    
    desc "Start nginx server on remote machine"
    task :start do
      sudo "/etc/init.d/nginx start"
    end
    
    desc "Stop nginx server on remote machine"
    task :stop do
      sudo "/etc/init.d/nginx stop"
    end
    
    desc "Restart nginx server on remote machine"
    task :restart do
      deploy.nginx.stop
      deploy.nginx.start
    end
  end
end

