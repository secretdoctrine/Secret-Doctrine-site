Refinery::Core::Engine.routes.draw do

  # Frontend routes
  namespace :feedback_entries do
    resources :feedback_entries, :path => '', :only => [:index, :new, :create]
  end

  # Admin routes
  namespace :feedback_entries, :path => '' do
    namespace :admin, :path => Refinery::Core.backend_route do
      resources :feedback_entries, :only => [:index, :show, :destroy]
    end
  end

end
