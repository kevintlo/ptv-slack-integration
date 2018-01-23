require 'ptv-api'

class IntegrationQuery
 attr_reader :disruptions, :slack_username 
 
 def initialize( options = {} )
  throw ArgumentError.new('Required argument :route_id missing') if options[:route_id].nil?
  throw ArgumentError.new('Required argument :username missing') if options[:username].nil?
  
  @ptv_route_id= options[:route_id]
  @slack_username= options[:username]
  
  # PTV_API_DEVID and PTV_API_KEY expected to be assigned in secrets.yml
  @ptv = PTV::Query.new(devid: Rails.application.secrets.PTV_API_DEVID, key: Rails.application.secrets.PTV_API_KEY)

  # SLACK_API_TOKEN expected to be assigned in secrets.yml
  @slack = Slack::Web::Client.new(token: Rails.application.secrets.SLACK_API_TOKEN)
 
  # Do User-lookup on Slack Workspace  
  workspace_users = @slack.users_list.members
   
  workspace_users.detect{|user| @slack_user_id = user.id if user.real_name == @slack_username  }
  
  # force-raise SlackError if User not existent in workspace
  if @slack_user_id.nil?
   @slack.users_info(user: 'foo')
  end
 end

 def retreiveDisruptions
   @disruptions= @ptv.disruptions_byId(route_id: @ptv_route_id)
 end
 
 def postMessage(options = {})
 throw ArgumentError.new('Required argument :notification missing') if options[:notification].nil?  
 @slack.chat_postMessage(channel: @slack_user_id, attachments: [options[:notification]].to_json) 
 end
end
