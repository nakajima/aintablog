namespace :migrate do
  desc "Move Link#cite to Link#content"
  task :links => :environment do
    Link.find(:all).each do |link|
      link.content ||= link.cite
      puts "updating link: #{link.permalink}" if link.save
      puts link.reload.content
    end
  end
end