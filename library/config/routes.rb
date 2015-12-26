Library::Engine.routes.draw do

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
  resources :pages, :only => [:show, :index]
  resources :book_categories, :only => [:show, :index]

end
