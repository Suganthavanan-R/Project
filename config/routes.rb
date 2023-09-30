Rails.application.routes.draw do
  root 'input#index'
  post 'generate_bill', to: 'input#generate_bill'

  # # Define resources for Bill and BillItem
  # resources :bills, only: [:new, :create, :show]
  # resources :line_items, only: [:create, :destroy]

  # Define a route to fetch products as JSON
  get '/products.json', to: 'products#index', defaults: { format: 'json' }
  resources :products
  get '/input/products_json', to: 'products#products_json'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
