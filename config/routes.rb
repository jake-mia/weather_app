Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'sessions#landing'

  post 'sessions/query' => 'sessions#query', as: "query"
  get 'sessions/success' => 'sessions#success', as: "success"
  get 'sessions/failure' => 'sessions#failure', as: "failure"

  #handle any UI errors
  if Rails.env.production?
   get '404', to: 'application#page_not_found'
   get '422', to: 'application#server_error'
   get '500', to: 'application#server_error'
  end
end
