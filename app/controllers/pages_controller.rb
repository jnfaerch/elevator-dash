class PagesController < ApplicationController
  require 'news-api'

  skip_before_action :authenticate_user!, only: [:home]

  def home
    @newsapi = News.new(ENV["newsapi_api_key"])
    @headlines = @newsapi.get_top_headlines(sources: "reuters")
  end
end
