class PostsController < ApplicationController
  POST_TYPE_PATTERN = /\/(articles|tweets|quotes|pictures|links|snippets|posts)(\.rss)?\/?/i
  
  rescue_from ActiveRecord::RecordNotFound, :with => :not_found
  
  before_filter :login_required, :except => [:index, :show]
    
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

  # GET /posts/new
  # GET /posts/new.xml
  def new
    @post = Post.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find_by_permalink(params[:id]) || Post.find(params[:id])
  end

  # POST /posts
  # POST /posts.xml
  def create
    post_type = params[:post][:type].tableize
    @post = current_user.send(post_type).build(params[:post])
    respond_to do |format|
      if @post.save
        expire_index!
        flash[:notice] = 'Post was successfully created.'
        format.html { redirect_to posts_path }
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
        expire_index!
        flash[:notice] = 'Post was successfully updated.'
        format.html { redirect_to post_path(@post) }
        format.js   { render :json => @post }
        format.xml  { head :ok }        
      else
        format.html { render :action => "edit" }
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
    expire_index!
    expire_fragment(@post.permalink)
    flash[:notice] = "The #{@post.type.downcase} was successfully destroyed."
    respond_to do |format|
      format.html { redirect_to(posts_url) }
      format.xml  { head :ok }
    end
  end
  
  # private
    def post_repo
      @post_type = params[:posts_type] || request.path.gsub(POST_TYPE_PATTERN, '\1')
      return @post_type.classify.constantize        
      rescue => e
        logger.info(e)
        @post_type = 'posts'
        return @post_type.classify.constantize
    end
    
    def not_found
      flash[:error] = "Sorry but that post could not be found."
      redirect_to '/' and return
    end
    
    def expire_index!
      expire_path('/index.html')
      expire_path('/posts.html')
      expire_path('/posts')
      expire_path("/#{@post.type.tableize}.html")
      expire_path("/#{@post.type.tableize}")
    end
end
