Rails.application.routes.draw do
  resources :enrollments do
    # collection do
    #   get :my_students
    # end
    # ↑ same
    get :my_students, on: :collection
    # member do
    #   get :certificate
    # end
    get :certificate, on: :member
  end
  # devise_for :users
  # devise_for :users, controllers: { sessions: 'users/sessions' }
  devise_for :users, :controllers => { registrations: 'users/registrations', omniauth_callbacks: 'users/omniauth_callbacks' }
  resources :courses do
    # collection: without args
    get "purchased", "review_pending", "teaching", "created", "unapproved", on: :collection
    resources :lessons do
      resources :comments, except: [:index]
      put :sort
      member do
        # delete path is routed to delete_video method
        delete :delete_video
      end
    end
    resources :enrollments, only: [:new, :create]
    # member: with args
    member do
      get :analytics
      patch :approve
      patch :unapprove
    end
  end
  resources :course_creator
  resources :tags, only: [:create, :destroy, :index]
  resources :users, only: [:index, :show, :edit, :update]
  get 'home/index'
  get 'home/activity'
  get 'home/analytics'
  get 'home/privacy_policy'
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
