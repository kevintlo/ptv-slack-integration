Rails.application.routes.draw do
 post '/disruptions', to: 'ptv#disruptions'
 root 'ptv#index'
end
