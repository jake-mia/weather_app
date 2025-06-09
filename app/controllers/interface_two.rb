class InterfaceTwo
  include HTTParty

  def self.call_api(postal_code,end_point)
    api_url = "http://api.weatherapi.com"
    api_version = "v1"
    api_key = Rails.application.credentials.api_key
    options = 'key=' + api_key + '&aqi=no'
    #response = HTTParty.get('http://api.weatherapi.com/v1/current.json?key=12345&q=' + postal_code + '&aqi=no')
    #self.class.get()
    self.get(api_url + "/" + api_version + "/" + end_point + "?" + options + '&q=' + postal_code)
  end

end
