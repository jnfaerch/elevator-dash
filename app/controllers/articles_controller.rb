class ArticlesController < ApplicationController
  require 'simple_form'

  def index
    @articles = Article.all
  end

  def show
    @article = Article.find(params[:id])
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)
    if @article.save
      @article.errors.full_messages
      redirect_to articles_path(@articles)
    else
      render 'new'
    end
  end

  def edit

  end

  def update

  end

  def destroy

  end

  private

  def article_params
    params.require(:article).permit(:imgURL, :header, :body, :live, :user_id)
  end

end
