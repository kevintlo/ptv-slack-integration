Rails.application.routes.draw do
 get '/disruptions', to: 'ptv#disruptions'
 root 'ptv#index'
end
