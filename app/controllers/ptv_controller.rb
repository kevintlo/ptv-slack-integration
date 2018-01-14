require 'ptv-api'

class PtvController < ApplicationController
 def index
 end

 def disruptions
  @query = IntegrationQuery.new(route_id: params[:route_id], username: params[:username])
  @query.retreiveDisruptions 
  #debugger
  # Count disruptions array entries for metro_train type
  @disruptions_count = @query.disruptions["metro_train"].count

  # Save array of disruption titles to post as Slack notifications
  @disruptions_title = []
  @query.disruptions["metro_train"].each do |disruption|
   @disruptions_title << disruption["title"]
  end 
 end
end
