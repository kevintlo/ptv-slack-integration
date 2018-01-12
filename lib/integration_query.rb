require 'ptv-api'

class IntegrationQuery
 attr_reader :disruptions 
 
 def initialize( options = {} )
  throw ArgumentError.new('Required argument :route_id missing') if options[:route_id].nil?
  throw ArgumentError.new('Required argument :username missing') if options[:username].nil?
  
  @ptv_route_id= options[:route_id]
  @slack_username= options[:username]
  
  # replace devid and key placeholder with valid PTV API credentials
  @ptv = PTV::Query.new(devid: Rails.application.secrets.PTV_API_DEVID, key: Rails.application.secrets.PTV_API_KEY)

  # replace token placeholder with valid Slack API token 
  @slack = Slack::Web::Client.new(token: 'xoxp-xxxxxxxxxxxx-xxxxxxxxx-xxxxxxxx-xxxxxxxxxxxxxxxxxxxxxxxxxx')
 end

 def retreiveDisruptions
   @disruptions= @ptv.disruptions_byId(route_id: @ptv_route_id)
 end
 
 def postMessage(options = {})
 throw ArgumentError.new('Required argument :text missing') if options[:text].nil?
 
 users_list = @slack.users_list
 user_id = ''

 users_list["members"].each do |member|
  if member["real_name"] == @slack_username
   user_id = member["id"]
  end
 end
 
 @slack.chat_postMessage(channel: user_id, text: "#{@disruptions["metro_train"].count} disruptions on your line")   
 # To-Do: (1) Verify slack user
 # 	  (2) Retreive User ID
 # 	  (3) Post Notification with disruption text
 end
end
