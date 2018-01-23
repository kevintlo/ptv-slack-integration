module PtvHelper
 def assembleDisruptionAlert(disruptions_count, disruptions_title=[], route_id, username)
   
 # part of the attachments array for the Slack notification
 fields= []
 attachments= Hash["fallback","PTV Disruptions Alert"] 

 # Save title for each appearing disruption in a hashed-array
 disruptions_title.each{|disruption| fields << { "title":  disruption }}

 # Construct Slack Notification
 if disruptions_count == 0
  attachments["color"] = "good"
  fields << { "title": "Hurray, no disruptions on the #{PTV::ROUTES.key(route_id.to_i)} line!" }
  attachments["fields"] = fields
 elsif
  attachments["color"] = "danger"
  attachments["pretext"] = "#{username} we detected #{disruptions_count} #{"disruption".pluralize(disruptions_count)} on the #{PTV::ROUTES.key(route_id.to_i)} line"
  attachments["fields"] = fields
 end
  
  attachments
 end
end
