class CommentsController < ApplicationController
  before_filter :login_required, :only => [:update, :destroy]
  before_filter :get_commentable
  skip_before_filter :verify_authenticity_token, :only => :update
  
  # GET /comments
  # GET /comments.xml
  def index
    redirect_to @commentable and return if @commentable
    access_denied and return unless logged_in?
    @spams = Comment.find_all_by_spam(true)
    @hams = Comment.find_all_by_spam(false)
  end

  # POST /comments
  # POST /comments.xml
  def create
    @comment = @commentable.comments.build(params[:comment])
    @comment.env = request.env
    respond_to do |format|
      if @comment.save
        flash[:notice] = 'Comment was successfully created.'
        format.html { redirect_to("#{url_for(@commentable)}#comments") }
        format.xml  { render :xml => @comment, :status => :created, :location => @commentable }
      else
        flash[:comment] = @comment
        format.html { redirect_to(@commentable) }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def update
    @comment = Comment.find(params[:id])
    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        format.html { redirect_to @commentable ? @commentable : comments_path }
        format.js   { render :json => @comment }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.js   { render :text => 'fail', :status => :unprocessable_entity }
        format.xml  { render :xml => @commentable.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.xml
  def destroy
    @comment = @commentable.comments.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to(@commentable) }
      format.xml  { head :ok }
    end
  end
  
protected
  
  def get_commentable
    id = params[:article_id] || params[:snippet_id]
    @commentable = Post.find_by_permalink(id)
  end
end
