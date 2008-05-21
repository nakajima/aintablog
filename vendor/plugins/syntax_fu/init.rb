config.load_paths += Dir["#{File.dirname(__FILE__)}/vendor/gems/**"].map do |dir| 
  File.directory?(lib = "#{dir}/lib") ? lib : dir
end


require 'syntax_fu'
