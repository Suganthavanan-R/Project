Rails.application.routes.draw do
  root 'input#index'
  post 'generate_bill', to: 'input#generate_bill'
  get '/products.json', to: 'products#index', defaults: { format: 'json' }
  resources :products
  get '/input/products_json', to: 'products#products_json'
end
