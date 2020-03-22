Rails.application.routes.draw do
  devise_for :users, skip: :registration
  root 'home#index'

  namespace :api do
    namespace :v1 do
      resources :projects, only: [:index, :destroy] do
        collection do
          post :create_or_update
        end
      end
      resources :project_steps, only: [:index, :destroy] do
        collection do
          get :get_project_step
          get :get_last_project_step
          get :get_last_project_step_by_params
          get :get_next_project_step
          get :get_prev_project_step
          post :create_or_update
        end
        member do
          get :priorities
          get :confidences
          get :next_projects
          get :health_metrics
        end
      end
    end
  end

  match "*path", to: "home#index", via: :get
end
