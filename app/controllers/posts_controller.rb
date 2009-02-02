class PostsController < Application
  @@subtypes = []
  cattr_reader :subtypes
  
  def self.expose_as(*types)
    options = types.extract_options!
    types.each do |name|
      PostsController.subtypes << name.to_s
      controller_title = options[:namespace].to_s + name.to_s.tableize.titleize + 'Controller'
      controller_class = Class.new(PostsController) do
        prepend_view_path File.join(Rails.root, *%w[app views posts])
        prepend_view_path File.join(Rails.root, *%w[app views posts types])
        prepend_view_path File.join(Rails.root, *%w[app views posts forms])
        define_method(:post_type) { name }
      end
      
      logger.info "=> Generating new #{options[:namespace]}PostsController subclass: #{controller_title}"
      
      Object.const_set(controller_title, controller_class)
    end
  end
  
  rescue_from ActiveRecord::RecordNotFound, :with => :not_found
  
  before_filter :redirect_to_admin, :if => :logged_in?
  
  caches_page :index
  caches_page :show
  
  expose_as :articles, :links, :pictures, :quotes, :snippets, :tweets, :gists
  
  # GET /posts
  # GET /posts.xml
  def index
    @posts = post_repo.paginate_index(:page => params[:page])
    respond_to do |format|
      format.html { render :template => 'posts/index.html.erb' }
      format.rss { render :template => 'posts/index.rss.builder' }
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
      format.html { render :template => 'posts/show.html.erb' }
      format.xml  { render :xml => @post }
    end
  end
  
  def default_template_name(action_name = self.action_name)
    if action_name
      action_name = action_name.to_s
      if action_name.include?('/') && template_path_includes_controller?(action_name)
        action_name = strip_out_controller(action_name)
      end
    end
    "#{self.controller_path}/#{action_name}"
  end
  
  private
  
  def post_type
    :post
  end
  
  def redirect_to_admin
    redirect_to admin_root_path + request.path
  end
end
