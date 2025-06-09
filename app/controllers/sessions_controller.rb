class SessionsController < ApplicationController

  def query
    #receive postal_code as a parameter from the form and call the api if needed
    @postal_code = params[:postal_code]

    #items are cached for 30 minutes when created
    if Rails.cache.exist?(@postal_code)
      #read data from cache
      puts "****** #{@postal_code} is cached already"
      set_cached_indicator
    else
      #call api and create a new cache entry
      puts "****** #{@postal_code} is not cached, calling api"

      #collect today's data (required)
      @today_response = InterfaceTwo.call_api(@postal_code,"current.json")
      build_result_object

      #collect forecast (optional)
      @forecast_response = InterfaceTwo.call_api(@postal_code,"forecast.json")
      update_result_object
    end

    choose_outcome

  end

  def success
    #interface call was a success render view
    #don't call interface.result_object because we want to share cache across users
    @result_object = Rails.cache.read(params[:postal_code])
  end

  def failure
    #interface call was a failure render view
    #don't call interface.result_object because we want to share cache across users
    @result_object = Rails.cache.read(params[:postal_code])
  end

  def landing
    #display landing page
    @modal_bg = "#f2f2f2"
  end

private

  def set_cached_indicator
    #add a new key, value to the hash so the front end knows is cached data
    result_object = Rails.cache.read(@postal_code)
    result_object[:cached_indicator] = true
    Rails.cache.write(@postal_code, result_object)
  end

  def build_result_object
    #create object to cache
    if @today_response.success?
      @result_object = {postal_code: @postal_code, response_code: @today_response.code, response_message: @today_response.message, save_time: DateTime.now, name: @today_response.parsed_response["location"]["name"], country: @today_response.parsed_response["location"]["country"], temp_f: @today_response.parsed_response["current"]["temp_f"], condition: @today_response.parsed_response["current"]["condition"]["text"] }
      Rails.cache.write(@postal_code, @result_object, expires_in: 30.minutes)
    else
      code = @today_response.code
      code ||= "500"
      message = @today_response.message
      message ||= "no response"
      @result_object = {postal_code: @postal_code, response_code: @today_response.code, response_message: @today_response.message, save_time: DateTime.now }
      Rails.cache.write(@postal_code, @result_object, expires_in: 5.seconds)
    end

  end

  def update_result_object
    #this is optional, add more keys to the cache, don't care if it fails
    if @forecast_response.success?
      @result_object[:day1] = @forecast_response.parsed_response["forecast"]["forecastday"][0]["date"] #"2025-05-19"
      @result_object[:day1_high] = @forecast_response.parsed_response["forecast"]["forecastday"][0]["day"]["maxtemp_f"] #"86.6"
      @result_object[:day1_text] =  @forecast_response.parsed_response["forecast"]["forecastday"][0]["day"]["condition"]["text"] #"sunny"
      Rails.cache.write(@postal_code, @result_object, expires_in: 30.minutes)
    else
      #do nothing
      puts "*** not adding the forecast data"
    end
  end

  def choose_outcome
    #choose which view to load
    if Rails.cache.read(@postal_code)[:response_code] == 200
      #api call was a success
      puts "****** success"
      #j render 'sessions/trigger_success'
      redirect_to success_path(:postal_code => @postal_code)
    else
      #api call was a failure
      puts "****** failure #{@today_response[:response_code]}"
      #j render 'sessions/trigger_failure'
      redirect_to failure_path(:postal_code => @postal_code)
    end
  end

end
