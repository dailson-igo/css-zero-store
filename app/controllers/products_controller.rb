class ProductsController < ApplicationController
  def index
    @products = Product.all.includes(:category)
  end

  def new
  end

  def show
  end

  def edit
  end
end
