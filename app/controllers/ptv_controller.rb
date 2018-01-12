require 'ptv-api'

class PtvController < ApplicationController
 def index
 end

 def disruptions
  @query = IntegrationQuery.new(route_id: params[:route], username: params[:name])
  @query.retreiveDisruptions
 end
end
