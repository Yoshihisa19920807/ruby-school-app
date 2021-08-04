Rails.application.routes.draw do
  resources :enrollments
  devise_for :users
  resources :courses do
    get "purchased", "review_pending", "created", "unapproved", on: :collection
    resources :lessons do
      put :sort
    end
    # collection: without args
    resources :enrollments, only: [:new, :create]
    # member: with args
    member do
      get :analytics
      patch :approve
      patch :unapprove
    end
  end
  resources :users, only: [:index, :show, :edit, :update]
  get 'home/index'
  get 'home/activity'
  get 'home/analytics'
  namespace :charts do
    get "users_per_day"
    get 'enrollments_per_day'
    get 'courses_per_day'
    get 'course_popularity'
    get 'money_makers'
  end
  # get 'charts/users_per_day', to: 'charts#users_per_day'
  # get 'charts/enrollments_per_day', to: 'charts#enrollments_per_day'
  # get 'charts/courses_per_day', to: 'charts#courses_per_day'
  # get 'charts/course_popularity', to: 'charts#course_popularity'
  # get 'charts/money_makers', to: 'charts#money_makers'
  
  root 'home#index'
  # root "static_pages#landing_page"
  # get 'static_pages/landing_page'
  # get 'static_pages/privacy_policy'
  # get 'privacy_policy', to: "static_pages#privacy_policy"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
