class Admin::PostsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, :with => :not_found
  
  before_filter :login_required
  
  after_filter :expire_index!, :only => [:create, :update, :destroy]
  after_filter :expire_post!, :only => [:update, :destroy]
  
  def self.for_type(name)
    define_method(:post_type) { name }
  end
  
  # GET /posts
  # GET /posts.xml
  def index
    @posts = post_repo.paginate_index(:page => params[:page])
    
    respond_to do |format|
      format.html { render :template => 'admin/posts/index.html.erb' }
    end
  end

  # GET /posts/1
  # GET /posts/1.xml
  def show
    @post = Post.find_by_permalink(params[:id], :include => :comments) || Post.find(params[:id])
    redirect_to admin_posts_path and return unless @post.type.match(/Article|Snippet/)
    @comment = flash[:comment] || @post.comments.build
    respond_to do |format|
      format.html { render :template => 'admin/posts/show.html.erb' }
      format.xml  { render :xml => @post }
    end
  end

  # GET /posts/new
  # GET /posts/new.xml
  def new
    @post = Post.new

    respond_to do |format|
      format.html { render :template => 'admin/posts/new.html.erb' }
      format.xml  { render :xml => @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find_by_permalink(params[:id]) || Post.find(params[:id])
    render :template => 'admin/posts/edit.html.erb'
  end

  # POST /posts
  # POST /posts.xml
  def create
    post_type = params[:post][:type].tableize
    @post = current_user.send(post_type).build(params[:post])
    respond_to do |format|
      if @post.save
        flash[:notice] = 'Post was successfully created.'
        format.html { redirect_to [:admin, @post] }
        format.xml  { render :xml => @post, :status => :created, :location => @post }
      else
        flash[:error] = @post.errors.full_messages
        format.html { redirect_to "#{new_post_path}##{params[:post][:type].downcase}" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.xml
  def update
    @post = Post.find_by_permalink(params[:id]) || Post.find(params[:id])
    params[:post] ||= params[@post.type.downcase]
    respond_to do |format|
      if @post.update_attributes(params[:post])
        expire_fragment(@post.permalink)
        flash[:notice] = 'Post was successfully updated.'
        format.html { redirect_to [:admin, @post] }
        format.js   { render :json => @post }
        format.xml  { head :ok }        
      else
        format.html { render :template => 'admin/posts/edit.html.erb' }
        format.js   { render :text => 'fail', :status => :unprocessable_entity }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.xml
  def destroy
    @post = Post.find_by_permalink(params[:id]) || Post.find(params[:id])
    @post.delete!
    expire_fragment(@post.permalink)
    flash[:notice] = "The #{@post.type.downcase} was successfully destroyed."
    respond_to do |format|
      format.html { redirect_to(admin_posts_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def post_type
    :post
  end
  
  def expire_post!
    expire_path("#{@post.link}.html")
  end
  
  def expire_index!
    expire_path('/index.html')
    expire_path('/posts.html')
    expire_path('/posts.rss')
    expire_path('/posts')
    expire_path("/#{@post.type.tableize}.html")
    expire_path("/#{@post.type.tableize}.rss")
    expire_path("/#{@post.type.tableize}")
  end
end
