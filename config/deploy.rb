namespace :cache do
  desc "Remove cache directory, essentially expiring the whole thing"
  task :expire do
    run "rm -rf #{current_path}/public/cache"
  end
end