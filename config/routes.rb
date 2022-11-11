Rails.application.routes.draw do
  root "questions#index"

  resources :questions, shallow: true do
    resources :answers, only: %i[new create edit update destroy]
  end
end
