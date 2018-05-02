class PagesController < ApplicationController
  require 'news-api'
  require 'open-uri'

  skip_before_action :authenticate_user!, only: [:home]

  def home
    @newsapi = News.new(ENV['newsapi_api_key'])
    @headlines = @newsapi.get_top_headlines(country: 'se')

    @busjson = JSON.load(busjson).to_hash
    @busno = @busjson.first[1].first["Product"]["num"] # The bus No
    @bustime = bustime # The next bus planned or real departure time - ie 19:46
    @bustime2 = bustime2 # The next bus after that
    @timenow = Time.now
    @hournow = Time.now.hour
    @minnow = Time.now.to_s.split[1][3..4].to_i
  end

  private

  def busjson
    open("https://api.resrobot.se/v2/departureBoard?key=#{ENV['resrobot_api_key']}&id=740015647&direction=740000003&maxJourneys=4&products=128&format=json").read
  end

  def bustime
    if @busjson.first[1][0]["Stops"]["Stop"][0]["rtDepTime"] == nil
      @busjson.first[1][0]["Stops"]["Stop"][0]["depTime"][0..4]
    else
      @busjson.first[1][0]["Stops"]["Stop"][0]["rtDepTime"][0..4]
    end
  end

  def bustime2
    if @busjson.first[1][1]["Stops"]["Stop"][0]["rtDepTime"] == nil
      @busjson.first[1][1]["Stops"]["Stop"][0]["depTime"][0..4]
    else
      @busjson.first[1][1]["Stops"]["Stop"][0]["rtDepTime"][0..4]
    end
  end

end
