class PostsController < ApplicationController
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
    redirect_to root_path and return unless @post.type.match(/Article|Snippet/)
    @comment = flash[:comment] || @post.comments.build
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post }
    end
  end
  
  private
    def redirect_to_admin
      redirect_to admin_root_path + request.path
    end
end
