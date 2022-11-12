Rails.application.routes.draw do
  root "questions#index"

  resources :questions, only: %i[index show new create], shallow: true do
    resources :answers, only: %i[new create]
  end
end
