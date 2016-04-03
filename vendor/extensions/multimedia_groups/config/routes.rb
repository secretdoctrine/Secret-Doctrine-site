Refinery::Core::Engine.routes.draw do

  # Frontend routes
  namespace :multimedia_groups do
    resources :multimedia_groups, :path => '', :only => [:index, :show] do
      resources :multimedia_items, :only => [] do
        get 'file', on: :member
      end
    end
  end

  # Admin routes
  namespace :multimedia_groups, :path => '' do
    namespace :admin, :path => Refinery::Core.backend_route do
      resources :multimedia_groups, :except => :show do
        collection do
          post :update_positions
        end
      end
    end
  end

  # Admin routes
  namespace :multimedia_groups, :path => '' do
    namespace :admin, :path => "#{Refinery::Core.backend_route}/multimedia_groups" do
      resources :multimedia_items, :except => :show do
        collection do
          post :update_positions
        end
      end
    end
  end

end
