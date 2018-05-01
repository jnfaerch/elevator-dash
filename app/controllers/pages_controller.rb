class PagesController < ApplicationController
  require 'news-api'
  require 'open-uri'

  skip_before_action :authenticate_user!, only: [:home]

  def home
    @newsapi = News.new(ENV['newsapi_api_key'])
    @headlines = @newsapi.get_top_headlines(country: 'se')
    @busjson = JSON.load(busjson).to_hash
    @busno = @busjson.first[1].first["Product"]["num"] # The bus No
    @adjusttime = @busjson.first[1][0]["Stops"]["Stop"][0]["depTime"][0..4] # The next bus planned departure time - ie 19:46
    @adjusttime2 = @busjson.first[1][1]["Stops"]["Stop"][0]["depTime"][0..4] # The next bus after that
    # @departure = ((((@adjusttime.to_time - Time.now) / 1.hour).modulo(24)) * 60).to_i
  end

  private

  def busjson
    open("https://api.resrobot.se/v2/departureBoard?key=#{ENV['resrobot_api_key']}&id=740015647&direction=740000003&maxJourneys=4&products=128&format=json").read
  end

end
