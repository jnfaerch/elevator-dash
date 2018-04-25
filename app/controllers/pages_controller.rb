class PagesController < ApplicationController
  require 'news-api'

  skip_before_action :authenticate_user!, only: [:home]

  def home
  end
end
