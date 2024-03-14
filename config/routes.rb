Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  resources :employees,only: [:create,:show] do

    member do
      get 'tax_deductions'
    end
  end

end
