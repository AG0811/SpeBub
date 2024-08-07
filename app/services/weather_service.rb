require 'net/http'
require 'json'

class WeatherService
  def initialize(api_key)
    @api_key = api_key
  end

  def fetch_weather_forecast(city)
    url = URI("http://api.openweathermap.org/data/2.5/forecast?q=#{city}&appid=#{@api_key}&units=metric")
    response = Net::HTTP.get(url)
    parsed_response = JSON.parse(response)

    if parsed_response['cod'] == '200'
      { success?: true, data: parsed_response['list'] }
    else
      { success?: false, message: parsed_response['message'] }
    end
  rescue StandardError => e
    { success?: false, message: e.message }
  end

  def icon_url(icon_code, size = '')
    "http://openweathermap.org/img/wn/#{icon_code}#{size}.png"
  end
end

