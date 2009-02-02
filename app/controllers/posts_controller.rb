class PostsController < Application
  include SingleControllerInheritance
  
  @@subtypes = []
  cattr_reader :subtypes # Used by feeds_controller to calculate cache expirations.
  
  before_filter :redirect_to_admin, :if => :logged_in?
  
  caches_page :index
  caches_page :show
  
  # Generates a new controller for each of these resources that will inherit
  # from PostsController, with the block being called for each.
  expose_as :articles, :links, :pictures, :quotes, :snippets, :tweets, :gists do |name|
    subtypes << name
    define_method(:post_type) { name }
  end
  
  # GET /posts
  # GET /posts.xml
  def index
    @posts = post_repo.paginate_index(:page => params[:page])
    respond_to do |format|
      format.html { render :template => 'posts/index.html.erb' }
      format.rss  { render :template => 'posts/index.rss.builder' }
      format.xml  { render :xml => @posts }
    end
  end

  # GET /posts/1
  # GET /posts/1.xml
  def show
    redirect_to root_path and return unless current_post.type.match(/Article|Snippet/)
    
    @comment = flash[:comment] || current_post.comments.build
    respond_to do |format|
      format.html { render :template => 'posts/show.html.erb' }
      format.xml  { render :xml => current_post }
    end
  end
  
  private
  
  def current_post
    @current_post ||= Post.find_by_permalink(params[:id], :include => :comments) || Post.find(params[:id])
  end
  
  def post_type
    :posts
  end
  
  def redirect_to_admin
    redirect_to admin_root_path + request.path
  end
end
