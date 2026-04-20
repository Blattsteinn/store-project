class DashboardController < ApplicationController
    before_action :authenticate_admin!

    def index
    end

    def products_index
        @products = Product.all.order(title: "desc")
        render "dashboard/product/products_index"
    end

    def orders_index
        @orders = Order.all.includes(order_items: [:variant])
        @orders = @orders.where(status: params[:status]) if params[:status].present?
        render "dashboard/order/orders_index"
    end

    def order_show
        @order = Order.includes(order_items: [:product, :variant]).find(params[:id])
        render "dashboard/order/order_show"
    end

end
