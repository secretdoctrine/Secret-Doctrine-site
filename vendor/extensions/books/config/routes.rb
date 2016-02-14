Refinery::Core::Engine.routes.draw do

  # Admin routes
  namespace :books, :path => '' do
    namespace :admin, :path => Refinery::Core.backend_route do
      resources :books, :except => :show do
        collection do
          post :update_positions
        end
      end
    end
  end

  # Admin routes
  namespace :books, :path => '' do
    namespace :admin, :path => "#{Refinery::Core.backend_route}/books" do
      resources :book_categories, :except => :show do
        collection do
          post :update_positions
        end
      end

      resources :contents_elements
    end
  end

  namespace :books, :path => '' do
    resources :search_results, :only => [:index] do
      get 'export', on: :collection
    end

    resources :books, :only => [:show] do
      resources :pages, :only => [:show] do
        get 'export', on: :member
        get 'redirect', on: :collection
        resources :external_page_contents, :only => [:show]
      end
      resources :external_book_contents, :only => [:show]
      get 'cover', on: :member
    end
    #resources :pages, :only => [:show, :index]
    resources :book_categories, :only => [:show, :index]
    end

end
