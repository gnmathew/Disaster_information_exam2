Rails.application.routes.draw do
  get 'csv_imports/new'
  get 'csv_imports/create'
  devise_for :users

  root 'posts#index'
  
  get 'welcome' => 'welcome#index'

  resources :csv_imports, only: [:new, :create]

  get '/export', to: 'export#export_to_csv'

  resources :posts

  resources :categories, except: :show
  
  get '/:short_url', to: 'posts#short_url_redirect'
  
  namespace :user do
    resources :posts, :comments
  end

  resources :posts do
    resources :comments, except: :show
  end

  namespace :api do
    namespace :v1 do
      resources :regions, only: %i[index show], defaults: { format: :json } do
        resources :provinces, only: :index, defaults: { format: :json }
      end

      resources :provinces, only: %i[index show], defaults: { format: :json } do
        resources :cities, only: :index, defaults: { format: :json }
      end

      resources :cities, only: %i[index show], defaults: { format: :json } do
        resources :barangays, only: :index, defaults: { format: :json }
      end

      resources :barangays, only: %i[index show], defaults: { format: :json }
    end
  end
end
