class OrdersController < ApplicationController
  def index
    @orders = Order.all.includes(:customer)
  end

  def new
  end

  def show
  end

  def edit
  end
end
