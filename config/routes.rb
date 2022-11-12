Rails.application.routes.draw do
  devise_for :users
  root "questions#index"

  resources :questions, only: %i[index show new create], shallow: true do
    resources :answers, only: %i[new create]
  end
end
