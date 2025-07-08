Rails.application.routes.draw do
  mount ActionCable.server => "/cable"

  namespace :api do
    resources :todo_lists, only: %i[index], path: :todolists do
      get :mark_all_as_completed, on: :member
      get :progress, on: :member
      resources :todo_items, only: %i[new create edit update show index destroy], module: :todo_lists
    end
  end

  resources :todo_lists, only: %i[new create edit update show index destroy ], path: :todolists do
    get :mark_all_as_completed, on: :member
    resources :todo_items, only: %i[new create edit update show index destroy], module: :todo_lists
  end
end
