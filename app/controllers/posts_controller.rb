class PostsController < ApplicationController
  before_filter :login_required, :except => [:index, :show]
  
  # GET /posts
  # GET /posts.xml
  def index
    @posts = Post.paginate(:order => 'posts.created_at DESC', :page => params[:page], :include => [:comments, :feed])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts }
    end
  end

  # GET /posts/1
  # GET /posts/1.xml
  def show
    @post = Post.find_by_permalink(params[:id], :include => :comments)
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
    @post = Post.find_by_permalink(params[:id])
  end

  # POST /posts
  # POST /posts.xml
  def create
    post_type = params[:post][:type].tableize
    @post = current_user.send(post_type).build(params[:post])
    respond_to do |format|
      if @post.save
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
    @post = current_user.posts.find_by_permalink(params[:id])
    respond_to do |format|
      if @post.update_attributes(params[@post.type.downcase])
        flash[:notice] = 'Post was successfully updated.'
        format.html { redirect_to post_path(@post) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.xml
  def destroy
    @post = Post.find_by_permalink(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to(posts_url) }
      format.xml  { head :ok }
    end
  end
end
