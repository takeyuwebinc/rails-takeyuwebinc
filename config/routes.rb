Rails.application.routes.draw do
  devise_for :administrators, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  MissionControl::Jobs.base_controller_class ="AdminController"
  authenticated :administrator do
    mount MissionControl::Jobs::Engine, at: "/admin/jobs"
  end
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :announcements, only: [ :show ]
  resources :contacts, only: [ :new, :create ]

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "home#index"

  resources :services, only: [ :index, :show ]
  resources :works, only: [ :index, :show ]
  resources :jobs, only: [ :index, :show ]
  resource :company, only: [ :show ]

  get "/service", to: redirect("/services")
  get "/service/ses", to: redirect("/services/remote_team")
  get "/service/consulting", to: redirect("/services/technichal_advisor")
  get "/service/development", to: redirect("/services/outsourcing")
  get "/recruit", to: redirect("/jobs")
  get "/aboutus", to: redirect("/company")
end
