Rails.application.routes.draw do
  namespace :api do
    get :todolists, controller: :todo_lists, action: :index
  end

  resources :todo_lists, only: %i[index new], path: :todolists
end
