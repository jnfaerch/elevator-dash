class PagesController < ApplicationController
  require 'news-api'
  require 'open-uri'
  require 'uri'
  require 'net/http'

  skip_before_action :authenticate_user!, only: [:home]

  def home
    @newsapi = News.new(ENV['newsapi_api_key'])
    @headlines = @newsapi.get_top_headlines(country: 'se')

    @busjson = busjson
    @busno = busno # The bus No
    @bustime = bustime # The next bus planned or real departure time - ie 19:46
    @bustime_hours = bustime_hours
    @bustime_minutes = bustime_minutes
    @bustime2 = bustime2 # The next departure after bustime
    @timenow = Time.now
    @hournow = Time.now.hour
    @minnow = Time.now.to_s.split[1][3..4]
  end

  private

  def online # Checks if resrobot api link is up!
    # uri = URI::HTTPS.build([nil, "api.resrobot.se", nil, "/v2/departureBoard", "key=#{ENV["resrobot_api_key"]}&id=740015647&direction=740000003&maxJourneys=4&products=128&format=json", nil])
    uri = URI.parse("https://api.resrobot.se/v2/departureBoard?key=#{ENV['resrobot_api_key']}&id=740015647&direction=740000003&maxJourneys=4&products=128&format=json")
    Net::HTTP.get_response(uri).code == "200"
  end

  def busjson
    if online
      bus = open("https://api.resrobot.se/v2/departureBoard?key=#{ENV['resrobot_api_key']}&id=740015647&direction=740000003&maxJourneys=4&products=128&format=json").read
        JSON.load(bus).to_hash
    end
  end

  def busno
    if online
      @busjson.first[1].first["Product"]["num"]
    end
  end

  def bustime
    if online
      if @busjson.first[1][0]["Stops"]["Stop"][0]["rtDepTime"] == nil
        @busjson.first[1][0]["Stops"]["Stop"][0]["depTime"][0..4]
      else
        @busjson.first[1][0]["Stops"]["Stop"][0]["rtDepTime"][0..4]
      end
    end
  end

  def bustime_hours
    if online
      bustime[0..1]
    end
  end

  def bustime_minutes
    if online
      bustime[3..4]
    end
  end

  def bustime2
    if online
      if @busjson.first[1][1]["Stops"]["Stop"][0]["rtDepTime"] == nil
        @busjson.first[1][1]["Stops"]["Stop"][0]["depTime"][0..4]
      else
        @busjson.first[1][1]["Stops"]["Stop"][0]["rtDepTime"][0..4]
      end
    end
  end

end
