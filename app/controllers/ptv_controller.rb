require 'ptv-api'

class PtvController < ApplicationController
 def index
 end

 def disruptions
  @query = IntegrationQuery.new(route_id: params[:route_id], username: params[:username])
  # @query.retreiveDisruptions
 end
end
