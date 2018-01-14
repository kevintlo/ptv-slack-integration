require 'ptv-api'

class IntegrationQuery
 attr_reader :disruptions 
 
 def initialize( options = {} )
  throw ArgumentError.new('Required argument :route_id missing') if options[:route_id].nil?
  throw ArgumentError.new('Required argument :username missing') if options[:username].nil?
  
  @ptv_route_id= options[:route_id]
  @slack_username= options[:username]
  
  # PTV_API_DEVID and PTV_API_KEY expected to be assigned in secrets.yml
  @ptv = PTV::Query.new(devid: Rails.application.secrets.PTV_API_DEVID, key: Rails.application.secrets.PTV_API_KEY)

  # SLACK_API_TOKEN expected to be assigned in secrets.yml
  @slack = Slack::Web::Client.new(token: Rails.application.secrets.SLACK_API_TOKEN)
 
  # Do User-Check and raise SlackError if not existent in workspace
  workspace_users = @slack.users_list.members
  workspace_user = workspace_users.detect{|user| user.real_name == @slack_username}
 
  if workspace_user.nil?
   @slack.users_info(user: 'foo')
  end
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
