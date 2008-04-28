class FeedsController < ApplicationController
  
  before_filter :login_required
  
  # GET /feeds
  # GET /feeds.xml
  def index
    @feeds = Feed.find(:all, :include => :posts)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @feeds }
    end
  end

  # GET /feeds/1
  # GET /feeds/1.xml
  def show
    @feed = Feed.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @feed }
    end
  end

  # GET /feeds/new
  # GET /feeds/new.xml
  def new
    @feed = Feed.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @feed }
    end
  end

  # GET /feeds/1/edit
  def edit
    @feed = Feed.find(params[:id])
  end

  # POST /feeds
  # POST /feeds.xml
  def create
    @feed = params[:feed][:type].constantize.new(params[:feed])

    respond_to do |format|
      if @feed.save
        flash[:notice] = 'The new feed was successfully created.'
        format.html { redirect_to(feeds_url) }
        format.xml  { render :xml => @feed, :status => :created, :location => @feed }
      else
        flash[:error] = 'The feed was unable to be created.'
        format.html { redirect_to(new_feed_path) }
        format.xml  { render :xml => @feed.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /feeds/1
  # PUT /feeds/1.xml
  def update
    feed = Feed.find(params[:id])
    @feed = feed.becomes(feed.type.constantize)
    respond_to do |format|
      begin
        @feed.update_attributes(params[feed.type.downcase])
        @feed.learn_attributes! # This should go in the model.
        flash[:notice] = "Your #{@feed.type} feed was successfully updated."
        format.html { redirect_to(feeds_url) }
        format.xml  { head :ok }
      rescue
        flash[:error] = "Your #{@feed.type} feed was unable to be updated."
        format.html { redirect_to(feeds_url) }
        format.xml  { render :xml => @feed.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /feeds/1
  # DELETE /feeds/1.xml
  def destroy
    @feed = Feed.find(params[:id])
    @feed.destroy
    flash[:notice] = 'The feed has been destroyed.'
    respond_to do |format|
      format.html { redirect_to(feeds_url) }
      format.xml  { head :ok }
    end
  end
  
  def refresh
    flash[:notice] = 'Your feeds have been refreshed.'
    @feeds = Feed.find(:all)
    @feeds.each(&:refresh!)
    respond_to do |format|
      format.html { redirect_to(feeds_url) }
      format.xml  { head :ok }
    end
  end
end
