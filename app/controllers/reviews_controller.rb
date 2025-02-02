class ReviewsController < ApplicationController
  def index
    @reviews = Review.all.includes(:customer, :product)
  end

  def new
  end

  def show
  end

  def edit
  end
end
