Rails.application.routes.draw do
  devise_for :users

  root 'posts#index'
  
  get 'welcome' => 'welcome#index'

  get '/import', to: 'posts#import_new', as: 'import_path'

  post '/import', to: 'posts#import_create'

  get '/export', to: 'posts#export_to_csv'

  resources :posts

  resources :categories, only: :index
  
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

  get '/:short_url', to: 'posts#short_url_redirect'
end
