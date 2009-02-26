# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  
  protect_from_forgery
  helper :all # include all helpers, all the time
  
  filter_parameter_logging :password, :password_confirmation
  
  def current_post
    @current_post ||= Post.find_by_permalink(params[:id], :include => :comments) || Post.find(params[:id])
  end
  
  protected 
  
  def post_repo
    begin
      @post_type = post_type.to_s.tableize
      @post_type.classify.constantize
    rescue => e
      logger.info(e)
      @post_type = :posts
      retry
    end
  end

  def not_found
    cookies[:error] = "Sorry but that post could not be found."
    redirect_to root_path and return
  end
  
  private
  
  def expire_path(file)
    file = File.join(Rails.root.to_str, 'public', file)
    FileUtils.rm_rf(file) if File.exists?(file)
    logger.info("Expired cache: #{file}")
  end
end
