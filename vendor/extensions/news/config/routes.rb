Refinery::Core::Engine.routes.draw do

  # Frontend routes
  namespace :'news', :path => '' do
    resources :'news_items', :only => [:index, :show]
    resources :'news_categories', :only => [:show]
    resources :'news_recipients', :only => [:create]
    resources :news_search_results, :only => [:index]
  end

  # Admin routes
  namespace :'news', :path => '' do
    namespace :admin, :path => Refinery::Core.backend_route do
      resources :'news_items', :except => :show do
        collection do
          post :update_positions
        end
      end
      resources :settings, :only => [:update]
    end
  end

end
