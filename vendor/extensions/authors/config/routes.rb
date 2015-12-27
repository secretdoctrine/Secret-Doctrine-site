Refinery::Core::Engine.routes.draw do

  # Frontend routes
  namespace :authors do
    resources :authors, :path => '', :only => [:index, :show]
  end

  # Admin routes
  namespace :authors, :path => '' do
    namespace :admin, :path => Refinery::Core.backend_route do
      resources :authors, :except => :show do
        collection do
          post :update_positions
        end
      end
    end
  end


  # Frontend routes
  namespace :authors do
    resources :poems, :only => [:index, :show]
  end

  # Admin routes
  namespace :authors, :path => '' do
    namespace :admin, :path => "#{Refinery::Core.backend_route}/authors" do
      resources :poems, :except => :show do
        collection do
          post :update_positions
        end
      end
    end
  end

end
