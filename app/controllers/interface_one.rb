class InterfaceOne
  include HTTParty

  def initialize
    #setup static interface values
    @api_url = "http://api.weatherapi.com"
    @api_version = "v1"
    @api_key = Rails.application.credentials.api_key
    @options = 'key=' + @api_key + '&aqi=no'
  end

  def call_api(postal_code,end_point)
    #response = HTTParty.get('http://api.weatherapi.com/v1/current.json?key=12345&q=' + postal_code + '&aqi=no')
    #self.class.get()
    @response = self.get(@api_url + "/" + @api_version + "/" + end_point + "?" + @options + '&q=' + postal_code)
  end

  def create_cache_entry(postal_code)

    if @response.present? && @response.code == 200 #@response.success?
      #HTTParty ran correctly
      #slim down data for caching and passing to the front end
      result_object = self.result_object(postal_code)
      #save the data to cache.  You could save this data to a model if it was important
      Rails.cache.write(postal_code, result_object, expires_in: 30.minutes)
    else
      #incase HTTParty blows up and there is no response object
      @code = self.code
      @code ||= "500"
      @message = self.message
      @message ||= "no response"
      #create a smaller error object
      result_object = {postal_code: postal_code, response_code: @code, response_message: @message, save_time: DateTime.now }
      #save data to cache for 5 seconds to allow the failure view to render
      Rails.cache.write(postal_code, result_object, expires_in: 5.seconds)
    end

  end

  def add_forecast_to_cache_entry(postal_code)
    #this is optional, add more keys to the cache, don't care if it fails
    if @response.present? && @response.code == 200
      #HTTParty ran correctly
      result_object = Rails.cache.read(postal_code)
      result_object[:day1] = @response.parsed_response["forecast"]["forecastday"][0]["date"] #"2025-05-19"
      result_object[:day1_high] = @response.parsed_response["forecast"]["forecastday"][0]["day"]["maxtemp_f"] #"86.6"
      result_object[:day1_text] =  @response.parsed_response["forecast"]["forecastday"][0]["day"]["condition"]["text"] #"sunny"
      Rails.cache.write(postal_code, result_object)
    else
      puts "****** sorry not able to collect the forecast ******"
    end
  end

  def result_object(postal_code)
    #return the cache object
    {postal_code: postal_code, response_code: @response.code, response_message: @response.message, save_time: DateTime.now, name: @response.parsed_response["location"]["name"], country: @response.parsed_response["location"]["country"], temp_f: @response.parsed_response["current"]["temp_f"], condition: @response.parsed_response["current"]["condition"]["text"] }
  end

  def code
    #return the HTTP code 200/404/etc
    @response.code
  end

  def message
    #return the HTTP message success/unauthorized/etc
    @response.message
  end

end
