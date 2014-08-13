class CartController < ApplicationController
  include ApplicationHelper

  after_action :save_current_cart

  def index
  end

  def add_item
    current_cart.add_item(params[:item_id])
    redirect_to root_path
  end

  def remove_item
    current_cart.remove_item(params[:item_id])
    redirect_to cart_path
  end
end
