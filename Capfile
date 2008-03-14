require 'capistrano/version'
load 'deploy' if respond_to?(:namespace) # cap2 differentiator
Dir['vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }

# =============================================================

# General configuration settings, required for all recipes!
set :application, "patnakajima.com"
set :domain, "patnakajima.com"
set :extra_domains, %w(www.patnakajima.com patnakajima.com)
role :app, domain
role :web, domain
role :db,  domain, :primary => true

set :user, "deploy"
set :group, "deploy"
default_run_options[:pty] = true
set :repository,  "git@github.com:nakajima/blog.git"
set :scm, "git"
set :branch, "origin/master"

# Deployment Settings
set :deploy_to, "/var/www/apps/#{application}"
set :config_files, %w(database.yml)

# SSH Keys for caching (you must generate these first.)
ssh_options[:keys] = %w(~/.ssh/id_dsa)

# =============================================================
# Thin Settings
# =============================================================
set :thin_servers, 1
set :thin_port, 8675
set :thin_environment, 'production'
set :thin_address, '127.0.0.1'
set :thin_conf, "#{shared_path}/config/thin.yml"

# =============================================================
# Nginx Settings
# =============================================================
set :nginx_sites_available, "/usr/local/nginx/sites-available"
set :nginx_sites_enabled, "/usr/local/nginx/sites-enabled"
