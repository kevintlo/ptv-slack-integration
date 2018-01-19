Rails.application.routes.draw do
 post '/disruptions', to: 'ptv#disruptions'
 get '/disruptions', to: 'ptv#index'
 root 'ptv#index'
end
