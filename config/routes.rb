Rails.application.routes.draw do
  devise_for :users
  root 'questions#index'

  resources :awards, only: :index
  resources :attachments, only: :destroy
  resources :links, only: :destroy

  concern :rateable do
    member do
      patch :uprate
      patch :downrate
      delete :cancel
    end
  end

  resources :questions, only: %i[index show new create destroy update], shallow: true, concerns: :rateable do
    resources :answers, only: %i[new create destroy update mark_as_best], concerns: :rateable do
      patch :mark_as_best, on: :member
    end
  end
end
