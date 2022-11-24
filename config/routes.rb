Rails.application.routes.draw do
  devise_for :users
  root 'questions#index'

  resources :awards, only: :index
  resources :attachments, only: :destroy
  resources :links, only: :destroy

  resources :questions, only: %i[index show new create destroy update], shallow: true do
    resources :answers, only: %i[new create destroy update mark_as_best] do
      patch :mark_as_best, on: :member
    end
  end
end
