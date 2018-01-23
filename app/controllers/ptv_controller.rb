require 'integration_query'

class PtvController < ApplicationController
 include PtvHelper

 def index
 end

 def disruptions
  @query = IntegrationQuery.new(route_id: params[:route_id], username: params[:username])
  @query.retreiveDisruptions 
  
  # Count disruptions array entries for metro_train type
  @disruptions_count = @query.disruptions["metro_train"].count

  # Save array of disruption titles to post as Slack notifications
  @disruptions_title = []
  @query.disruptions["metro_train"].each do |disruption|
   @disruptions_title << disruption["title"]
  end

  disruptions_alert = assembleDisruptionAlert(@disruptions_count, @disruptions_title, params[:route_id], params[:username])
  @query.postMessage(notification: disruptions_alert)

  rescue Slack::Web::Api::Errors::SlackError => error
   if error.response.body.error == "user_not_found"
    flash[:danger] = "Slack user #{params[:username]} does not exist in your workspace"
   end
    redirect_to root_url
 end
end
