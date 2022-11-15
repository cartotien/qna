Rails.application.routes.draw do
  devise_for :users
  root "questions#index"

  resources :questions, only: %i[index show new create destroy], shallow: true do
    resources :answers, only: %i[new create destroy]
  end
end
