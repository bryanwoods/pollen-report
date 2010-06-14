require 'rubygems'
require 'sinatra'
require 'haml'
require 'mechanize'

class PollenReport
  BASE_URL = "http://www.wunderground.com/DisplayPollen.asp?Zipcode="

  def initialize
    @agent = Mechanize.new
  end

  def lookup(zipcode)
    page = @agent.get(BASE_URL + zipcode)
    pollen_level = page.search(".dataTable td")[9]
    city_name = page.search("h1").text.gsub("Pollen Index for ", "")

    if pollen_level
      "Current pollen levels for #{city_name}: " + pollen_level
    else
      "Sorry, couldn't find any pollen information for #{city_name}."
    end
  end
end

get '/' do
  "<h1>To get started: <a href='/lookup/90210'><script type='text/javascript'>
  document.write(window.location.href);</script>lookup/90210</a></h1>"
end

get '/lookup/:zipcode' do
  pollen_report = PollenReport.new
  @lookup_report = pollen_report.lookup(params[:zipcode])
  haml '%h1= @lookup_report'
end

