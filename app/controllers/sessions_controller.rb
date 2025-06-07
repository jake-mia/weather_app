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
      #call api and create a new cache
      puts "****** #{@postal_code} is not cached, calling api"
      #collect today's data (required)
      ##interface = Interface.new

      ##interface.call_api(@postal_code,"forecast.json")
      ##interface.add_forecast_to_cache_entry(@postal_code)

      #collect forecast (optional)
      ##interface.call_api(@postal_code,"current.json")
      ##interface.create_cache_entry(@postal_code)

      #collect today's data (required)
      InterfaceTwo.call_api(@postal_code,"current.json")
      InterfaceTwo.create_cache_entry(@postal_code)

      #collect forecast (optional)
      InterfaceTwo.call_api(@postal_code,"forecast.json")
      InterfaceTwo.add_forecast_to_cache_entry(@postal_code)
    end

    choose_outcome

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
      puts "****** failure #{Rails.cache.read(@postal_code)[:response_code]}"
      #j render 'sessions/trigger_failure'
      redirect_to failure_path(:postal_code => @postal_code)
    end
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

end
