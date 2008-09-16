# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  
  helper :all # include all helpers, all the time
  
  filter_parameter_logging :password, :password_confirmation

  protect_from_forgery :secret => 'ad5fcf9cf9a6c79ef7b70f6ff02c6fca8e6692d9cd48306a21f27be3e36658f49234fe'
  
  skip_before_filter :verify_authenticity_token # Page caching screws up forgery protection stuff
  
  POST_TYPE_PATTERN = /\/(articles|tweets|quotes|pictures|links|snippets|posts)(\.rss)?\/?/i
  
  def expire_path(file)
    file = RAILS_ROOT + '/public' + file
    FileUtils.rm_rf(file) if File.exists?(file)
    logger.info("Expired cache: #{file}")
  end
  
  protected 
    def post_repo
      
      # two replaces, but it's better than duped code.
      @post_type = params[:posts_type] || request.path.gsub(/^\/admin/, '/').gsub(POST_TYPE_PATTERN, '\1')

      # for some reason '/' this gets classified as '::', which is an Object. Adding a check for that.
      throw NameError if @post_type.eql?('/')
    
      return @post_type.classify.constantize  
      rescue => e
        logger.info(e)
        @post_type = 'posts'
        return @post_type.classify.constantize
    end
  
    def not_found
      cookies[:error] = "Sorry but that post could not be found."
      redirect_to '/' and return
    end

end
