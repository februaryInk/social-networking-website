Rails.application.routes.draw do

    root :to => 'core_pages#home'
    
    resources :posts, :controller => 'forum_posts', :only => [ :create, :destroy ]
    resources :users
    
    scope( :path => '/forum' ) do
        resources :threads, :controller => 'forum_threads'
    end

    get '/about', :to => 'core_pages#about', :as => 'about'
    
    get '/help',                 :to => 'help_pages#help_center',     :as => 'help'
    get '/help/contact',         :to => 'help_pages#contact',         :as => 'contact'
    get '/help/faq',             :to => 'help_pages#faq',             :as => 'faq'
    get '/help/getting_started', :to => 'help_pages#getting_started', :as => 'getting_started'
    
    get '/forum', :to => 'forum_boards#index', :as => 'forum'
    
    get    '/signin',  :to => 'sessions#new'
    post   '/signin',  :to => 'sessions#create'
    delete '/signout', :to => 'sessions#destroy', :as => 'signout'
end
