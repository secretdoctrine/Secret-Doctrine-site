Refinery::Core::Engine.routes.draw do

  # Frontend routes
  namespace :'news_items' do
    resources :'news_items', :path => '', :only => [:index, :show]
    resources :'news_recipients', :only => [:create]
  end

  # Admin routes
  namespace :'news_items', :path => '' do
    namespace :admin, :path => Refinery::Core.backend_route do
      resources :'news_items', :except => :show do
        collection do
          post :update_positions
        end
      end
    end
  end

end
