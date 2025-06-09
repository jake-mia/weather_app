# README

This project was created for a code assessment.

* Ruby version
  3.1.6

* Rails version
  Rails 6.1.7.8  #this job said it was for Rails v5x/6x so I used this version

* System dependencies
  - rbenv is already installed
  - javascript is already installed on your system (webpacker will want this for basic install)
  - added HTTParty gem to Gemfile  (will be in repo already)

* Setup Instructions
  - from your project folder...
  - git remote add origin https://jake-mia@github.com/jake-mia/weather_app.git
  - cd weather_app
  - rbenv install 3.1.6, rbenv local 3.1.6
  - gem install rails -v 6.1.7.8
  - bundle install
  - I kept getting a logger error trying to start rails, here is the fix:
   vi ~/.rbenv/versions/3.1.6/lib/ruby/gems/3.1.0/gems/activesupport-6.1.7.8/lib/active_support/logger_thread_safe_level.rb


    require 'logger' <= add this line above the line below

    module ActiveSupport
    

  - You may need to delete yarn.lock, not sure
  - webpacker:install  #you could do "--skip-javascript" during creation, but i want to keep the options open, so i ran it for a basic install
  - bin/rails dev:cache (turn on caching in dev, one time)
  - rails db:create db:migrate (ran this only to satisfy minitest, I have no models)


* bootstrap/jquery dependencies, I wasn't able to get it working , so you should be able to skip this
  - yarn add bootstrap
  - yarn add jquery
  - yarn add jquery-ui
  - yarn add jquery-blockui
  - yarn add '@babel/plugin-proposal-private-methods'
  - yarn add '@babel/plugin-proposal-private-property-in-object'

* testing
  - rails test:system (should run minitest, below is output sample)

rails test:system

Run options: --seed 26517

Running:

Capybara starting Puma...
* Version 5.6.9, codename: Birdie's Version
* Min threads: 0, max threads: 4
* Listening on http://127.0.0.1:59663
Capybara starting Puma...
* Version 5.6.9, codename: Birdie's Version
* Min threads: 0, max threads: 4
* Listening on http://127.0.0.1:59674
.****** 2 is not cached, calling api
Capybara starting Puma...
* Version 5.6.9, codename: Birdie's Version
* Min threads: 0, max threads: 4
* Listening on http://127.0.0.1:59707
****** failure 400
.****** 33140 is not cached, calling api
****** success
.

Finished in 4.648066s, 0.6454 runs/s, 0.6454 assertions/s.
3 runs, 3 assertions, 0 failures, 0 errors, 0 skips



* api success object current endpoint:
response.parsed_response =
{"location"=>{"name"=>"Miami", "region"=>"Florida", "country"=>"USA", "lat"=>25.8521003723145, "lon"=>-80.1820983886719, "tz_id"=>"America/New_York", "localtime_epoch"=>1747691536, "localtime"=>"2025-05-19 17:52"}, "current"=>{"last_updated_epoch"=>1747691100, "last_updated"=>"2025-05-19 17:45", "temp_c"=>30.6, "temp_f"=>87.1, "is_day"=>1, "condition"=>{"text"=>"Sunny", "icon"=>"//cdn.weatherapi.com/weather/64x64/day/113.png", "code"=>1000}, "wind_mph"=>12.5, "wind_kph"=>20.2, "wind_degree"=>139, "wind_dir"=>"SE", "pressure_mb"=>1014.0, "pressure_in"=>29.94, "precip_mm"=>0.0, "precip_in"=>0.0, "humidity"=>63, "cloud"=>25, "feelslike_c"=>35.2, "feelslike_f"=>95.4, "windchill_c"=>30.8, "windchill_f"=>87.4, "heatindex_c"=>36.4, "heatindex_f"=>97.6, "dewpoint_c"=>24.8, "dewpoint_f"=>76.7, "vis_km"=>16.0, "vis_miles"=>9.0, "uv"=>3.9, "gust_mph"=>14.4, "gust_kph"=>23.2}}

* api failure object:
response = {"error"=>{"code"=>1006, "message"=>"No matching location found."}}

* api success forecast endpoint:
response.parsed_response =
{"forecast": {
        "forecastday": [
            {
                "date": "2025-05-21",
                "date_epoch": 1747785600,
                "day": {
                    "maxtemp_c": 20.7,
                    "maxtemp_f": 69.3,
                    "mintemp_c": 11.1,
                    "mintemp_f": 51.9,
                    "avgtemp_c": 15.4,
                    "avgtemp_f": 59.8,
                    "maxwind_mph": 11.4,
                    "maxwind_kph": 18.4,
                    "totalprecip_mm": 0.0,
                    "totalprecip_in": 0.0,
                    "totalsnow_cm": 0.0,
                    "avgvis_km": 10.0,
                    "avgvis_miles": 6.0,
                    "avghumidity": 52,
                    "daily_will_it_rain": 0,
                    "daily_chance_of_rain": 0,
                    "daily_will_it_snow": 0,
                    "daily_chance_of_snow": 0,
                    "condition": {
                        "text": "Partly Cloudy ",
                        "icon": "//cdn.weatherapi.com/weather/64x64/day/116.png",
                        "code": 1003
                    },
                    "uv": 1.3
                },
                "astro": {
                    "sunrise": "05:00 AM",
                    "sunset": "08:55 PM",
                    "moonrise": "02:36 AM",
                    "moonset": "01:26 PM",
                    "moon_phase": "Waning Crescent",
                    "moon_illumination": 45,
                    "is_moon_up": 0,
                    "is_sun_up": 0
                },
                "hour": [
                    { ...
