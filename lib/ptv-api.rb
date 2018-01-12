module PTV
 
  # Constant to list all PTV Lines. Prevent from modifications 
  ROUTES= { "Alamein": 1 ,
	"Belgrave": 2,
	"Craigieburn": 3,
	"Cranbourne": 4,
	"South Morang": 5,
	"Frankston": 6,
	"Glen Waverley": 7,
	"Hurstbridge": 8,
	"Lilydale": 9,
	"Pakenham": 11,
	"Sandringham": 12,
	"Stony Point": 13,
	"Sunbury": 14,
	"Upfield": 15,
	"Werribee": 16,
	"Williamstown": 17,
	"Showgrounds / Flemington Racecourse": 1482 }.freeze

 class Query
  attr_accessor :devid, :key
  attr_reader :ptv_api_response
  
   # Class Variable - constant information applicable to every instance 
   @@base_url= 'https://timetableapi.ptv.vic.gov.au' 


  # Simulated keyword arguments through a hash splat
  def initialize(options = {} )
   raise ArgumentError, 'Required argument :devid missing' if options[:devid].nil? 
   raise ArgumentError, 'Required argument :key missing' if options[:key].nil?
    
   @devid= options[:devid]
   @key= options[:key]
  end

  def signature(api_query)
   OpenSSL::HMAC.hexdigest('sha1', key, api_query)
  end

  #
  # GET - /v3/route_types
  # All route types (i.e. identifiers of transport modes) and their names.
  #
  def route_types
   api_request_string = "/v3/route_types/?devid=#{devid}"

   @ptv_api_response= request(api_request_string)
   
   ActiveSupport::JSON.decode(ptv_api_response.body)["route_types"]
  end

  #
  # GET - /v3/routes  
  # Route names and numbers for all routes of all route types.
  # 
  # Options:
  #	route_types: route type value [integer]
  # 	route_name: route name [string]
  def routes(options = {})
   # specify API name
   api_request_string = "/v3/routes?"

   options.each do |key, value| 
    api_request_string += "#{key}=#{value}&" 
   end
   
    api_request_string += "devid=#{devid}" 
   
   @ptv_api_response= request(api_request_string)

   ActiveSupport::JSON.decode(ptv_api_response.body)["routes"]
  end 

  # 
  # GET - /v3/disruptions
  # All disruption information for all route types.
  # 
  #
  def disruptions( options = {} )
  
   # specify API name
   api_request_string = "/v3/disruptions?"
   
   # loop through options hash and add to query string via interpolation
   options.each do |key, value|
    api_request_string += "#{key}=#{value}&"
   end
   
   api_request_string += "devid=#{devid}"
   
   @ptv_api_response= request(api_request_string)
   
   # case statement control structure 
   case options[:route_types]
   when 0, "Train"
    ActiveSupport::JSON.decode(ptv_api_response.body)["disruptions"]["metro_train"]
   when 1, "Tram" 
    ActiveSupport::JSON.decode(ptv_api_response.body)["disruptions"]["metro_tram"]
   when 2, "Bus" 
    ActiveSupport::JSON.decode(ptv_api_response.body)["disruptions"]["metro_bus"]
   when 3, "Vline" 
    ActiveSupport::JSON.decode(ptv_api_response.body)["disruptions"]["regional_train"]
   when 4, "Night Bus" 
    ActiveSupport::JSON.decode(ptv_api_response.body)["disruptions"]["metro_bus"]
   when nil 
    ActiveSupport::JSON.decode(ptv_api_response.body)["disruptions"]
   end
  end
  
  #
  # GET - /v3/disruptions/route/{route_id}
  # All disruption information (if any exists) for the specified route.
  #
  # Options:
  #	route_id: Identifier of route [integer]
  #	disrupton_status: Status of disruption (current / planned) [string]
  # 
  def disruptions_byId( options = {} )
    throw ArgumentError.new('Required arguments :route_id missing') if options[:route_id].nil?
  
    #specify API name
    api_request_string = "/v3/disruptions/route/#{options[:route_id]}?"

    if options.key?(:disruption_status)
     api_request_string += "disruption_status=#{options[:disruption_status]}&"
    end
   
    api_request_string += "devid=#{devid}"

    @ptv_api_response = request(api_request_string)
    
    ActiveSupport::JSON.decode(ptv_api_response.body)["disruptions"]
  end

  def status_code
   ptv_api_response.code
  end

  def status_message
   ptv_api_response.message
  end

 private 
 
  #
  # Helper function to actually execute API requests
  # 
  #
  #
  def request(api_request_string)
   api_request_signature = signature(api_request_string)

   api_query_string = "#{@@base_url}#{api_request_string}&signature=#{api_request_signature}"
   
   Net::HTTP.get_response(URI(api_query_string)) 
  end

 end
end
