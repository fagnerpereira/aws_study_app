Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Root route
  root "domains#index"

  # Games routes
  get "games", to: "games#index"
  get "games/service-match", to: "games#service_match"
  post "games/service-match/check", to: "games#check_service_match"
  get "games/architecture-challenge", to: "games#architecture_challenge"
  post "games/architecture-challenge/check", to: "games#check_architecture"
  get "games/cost-calculator", to: "games#cost_calculator"
  post "games/cost-calculator/check", to: "games#check_cost"
  get "games/quick-quiz", to: "games#quick_quiz"
  post "games/quick-quiz/check", to: "games#check_quiz"
  get "games/scenario-tree", to: "games#scenario_tree"
  post "games/scenario-tree/check", to: "games#check_scenario"

  # Authentication routes
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  # User registration
  get "signup", to: "users#new"
  post "signup", to: "users#create"
  get "profile", to: "users#show"

  # Study content routes
  resources :domains, only: [ :index, :show ] do
    resources :lessons, only: [ :show ] do
      member do
        post :complete
        post :answer_question
        get :flashcards
        get :test_mode # New route for test mode
      end
    end
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
