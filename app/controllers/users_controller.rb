class UsersController < ApplicationController
  # render new.rhtml
  def new
    redirect_to '/' if (User.count >= 1) && !logged_in?
    @user = User.new
  end

  def create
    cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with 
    # request forgery protection.
    # uncomment at your own risk
    # reset_session
    @user = User.new(params[:user])
    @user.save
    if @user.errors.empty?
      self.current_user = @user
      redirect_back_or_default('/')
      cookies[:notice] = "Thanks for signing up! Choose one of the links at the top to do something interesting."
    else
      render :action => 'new'
    end
  end
end
