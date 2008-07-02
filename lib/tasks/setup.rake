namespace :aintablog do  
  desc "Create default config files"
  task :setup do
    %w(database defensio settings).each do |file|
      puts "=> copying #{file} file"
      origin = File.join(RAILS_ROOT, 'config', "#{file}.yml.sample")
      target = File.join(RAILS_ROOT, 'config', "#{file}.yml")
      FileUtils.cp(origin, target)
    end
  end
end