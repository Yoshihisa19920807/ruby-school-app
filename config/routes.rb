Rails.application.routes.draw do
  resources :enrollments
  devise_for :users
  resources :courses do
    get "purchased", "review_pending", "created", on: :collection
    resources :lessons
    resources :enrollments, only: [:new, :create]
  end
  resources :users, only: [:index, :show, :edit, :update]
  get 'home/index'
  get 'home/activity'
  get 'home/analytics'
  get 'charts/users_per_day', to: 'charts#users_per_day'
  get 'charts/enrollments_per_day', to: 'charts#enrollments_per_day'
  get 'charts/courses_per_day', to: 'charts#courses_per_day'
  root 'home#index'
  # root "static_pages#landing_page"
  # get 'static_pages/landing_page'
  # get 'static_pages/privacy_policy'
  # get 'privacy_policy', to: "static_pages#privacy_policy"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
