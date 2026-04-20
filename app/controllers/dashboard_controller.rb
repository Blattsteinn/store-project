class DashboardController < ApplicationController
    before_action :authenticate_admin!

    def index
        
    end

    def products_view
        @products = Product.all
    end

    def product_view
        @product = Product.find(params[:id])
    end

    def orders_index
        @orders = Order.all.includes(order_items: [:variant])
        @orders = @orders.where(status: params[:status]) if params[:status].present?
    end

    def order
        @order = Order.includes(order_items: [:product, :variant]).find(params[:id])
        
    end

end
