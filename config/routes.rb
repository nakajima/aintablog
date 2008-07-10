ActionController::Routing::Routes.draw do |map|
  map.resources :feeds, :collection => { :refresh => :post }  
  map.resources :posts
  map.resources :users
  map.resource  :session
  map.resources :articles, :controller => 'posts', :has_many => :comments
  map.resources :quotes, :controller => 'posts'
  map.resources :pictures, :controller => 'posts'
  map.resources :tweets, :controller => 'posts'
  map.resources :links, :controller => 'posts'
  map.resources :snippets, :controller => 'posts', :has_many => :comments
  map.resources :comments, :member => { :report => :put }
  
  # allow for page links like "/posts/page/2"
  map.connect '/:posts_type/page/:page', :controller => 'posts'

  map.signup '/signup', :controller => 'users', :action => 'new'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  
  map.root :controller => 'posts'
end
