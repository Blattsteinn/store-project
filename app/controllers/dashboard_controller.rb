class DashboardController < ApplicationController
    before_action :authenticate_admin!

    def index
        @revenue = Order.where(status: "paid").joins(:order_items)
                        .sum("order_items.price * order_items.quantity")

        @total_orders    = Order.count
        @paid_orders     = Order.where(status: "paid").count
        @pending_orders  = Order.where(status: "pending").count
        @recent_orders   = Order.order(created_at: :desc).limit(8)
        @open_support    = SupportMessage.where(status: "open").count
    end

    def products_index
        @products = Product.includes(:variants).order(title: "desc")
        render "dashboard/product/products_index"
    end

    def orders_index
        @orders = Order.all
        @orders = @orders.where(status: params[:status]) if params[:status].present?
        render "dashboard/order/orders_index"
    end

    def order_show
        @order = Order.includes(order_items: [:product, :variant]).find(params[:id])
        render "dashboard/order/order_show"
    end

    def feedback_index
        @feedbacks = Feedback.all
        render "dashboard/feedback/feedback_index"
    end

    def feedback_show
        @feedback = Feedback.includes(:order).find(params[:id])
        render "dashboard/feedback/feedback_show"
    end

    def faq_index
        @faqs = Faq.all
        render "dashboard/faq/faq_index"
    end

end
