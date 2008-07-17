class PostsController < ApplicationController
  POST_TYPE_PATTERN = /\/(articles|tweets|quotes|pictures|links|snippets|posts)(\.rss)?\/?/i
  
  rescue_from ActiveRecord::RecordNotFound, :with => :not_found
  
  before_filter :redirect_to_admin, :if => :logged_in?
  
  caches_page :index
  caches_page :show
  
  # GET /posts
  # GET /posts.xml
  def index
    @posts = post_repo.paginate_index(:page => params[:page])
    respond_to do |format|
      format.html # index.html.erb
      format.rss { render :action => 'index.rss.builder' }
      format.xml { render :xml => @posts }
    end
  end

  # GET /posts/1
  # GET /posts/1.xml
  def show
    @post = Post.find_by_permalink(params[:id], :include => :comments) || Post.find(params[:id])
    redirect_to '/' and return unless @post.type.match(/Article|Snippet/)
    @comment = flash[:comment] || @post.comments.build
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post }
    end
  end
  
  private
    def post_repo
      @post_type = params[:posts_type] || request.path.gsub(POST_TYPE_PATTERN, '\1')
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
    
    def redirect_to_admin
      redirect_to "/admin" + request.path
    end
end
