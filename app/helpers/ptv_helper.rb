module PtvHelper
 @digest = OpenSSL::Digest.new('sha1')


 def ptv_signature(api_request)
  OpenSSL::HMAC.hexdigest('sha1', PTV_KEY, api_request)
 end

 def ptv_query_string(api_name, query_parameter = nil)
  request = "" 

  if api_name == "disruptions"
   request = "/v3/disruptions/route/#{query_parameter}"
  end   

  request += "?devid=#{PTV_DEVID}"
  signature = ptv_signature(request)
  
  api_query_string = "#{PTV_BASE_URL}#{request}&signature=#{signature}"

  return api_query_string 
 end

 def ptv_api_request(api_name, query_parameter)
  api_request = ptv_query_string(api_name, query_parameter)

  response = Net::HTTP.get_response(URI(api_request))
  
  return response
 end
end
