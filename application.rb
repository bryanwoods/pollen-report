require 'rubygems'
require 'sinatra'
require 'mechanize'

class PollenReport
  BASE_URL = "http://www.wunderground.com/DisplayPollen.asp?Zipcode="

  def initialize(zipcode)
    @agent = Mechanize.new
    @zipcode = zipcode
  end

  def lookup
    page = @agent.get(BASE_URL + @zipcode)
    pollen_level = page.search(".dataTable td")[9]
    city_name = page.search("h1").text.gsub("Pollen Index for ", "")

    if pollen_level
      "Current air quality in #{city_name}: " + pollen_level
    else
      "Sorry, couldn't find any air quality information for #{city_name}."
    end
  end
end

get '/' do
  "<h1>To get started: <a href='/lookup/90210'><script type='text/javascript'>
  document.write(window.location.href);</script>lookup/90210</a></h1>"
end

get '/lookup/:zipcode' do
  pollen_report = PollenReport.new(params[:zipcode])
  @lookup_report = pollen_report.lookup
  '<h1>' + @lookup_report + '</h1>'
end

