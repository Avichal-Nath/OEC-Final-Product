module Clients
  class HomeController < ApplicationController
    before_action :authenticate_user!, except: [:index] # or appropriate actions

    def index
      @featured_products = Product.limit(4) # Fetch featured products
      @on_sale_products = Product.on_sale.limit(4) # Fetch on-sale products
      @best_selling_products = Product.best_selling.limit(4) # Fetch best-selling products
      @new_arrivals = Product.new_arrivals.limit(4) # Fetch new arrivals
      @categories = Category.all
    end
  end
end
