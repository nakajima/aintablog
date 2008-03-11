ActionController::Routing::Routes.draw do |map|
  map.resources :posts
  map.resources :users
  map.resource :session
  map.resources :articles, :controller => 'posts'

  map.signup '/signup', :controller => 'users', :action => 'new'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  
  map.root :controller => 'posts'
end
