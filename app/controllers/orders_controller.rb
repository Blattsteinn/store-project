class OrdersController < ApplicationController
    # pending, paid, processing, delivered, cancelled, refunded.
    before_action :authenticate_admin!, only: [ :update, :destroy ]

    def index
        @orders = Order.where(user_id: current_user.id)
    end

    def show
        @order = current_user.orders.includes(order_items: [:product, :variant]).find(params[:id])
    end

    def create
        if session[:cart].blank?
            redirect_to cart_path, alert: "Cart is empty" and return
        end

        cart_items = session[:cart].map do |variant_id, quantity|
            [ Variant.find(variant_id), quantity ]
        end

        # Validate all stock before touching the DB
        ActiveRecord::Base.transaction do
            cart_items.each do |variant, quantity|
                variant.lock!
                raise ActiveRecord::Rollback if variant.stock < quantity
                variant.update!(stock: variant.stock- quantity.to_i)
            end

            @order = Order.create!(user_id: current_user.id)
            cart_items.each do |variant, quantity|
                product = variant.product
                OrderItem.create!(
                        order_id: @order.id,
                        product_id: product.id,
                        variant_id: variant.id,
                        quantity: quantity,
                        price: variant.price)
                
            end
        end
        session[:cart] = {}
        redirect_to order_path(@order), notice: "Order created successfully"
    end

    def update
        @order = Order.find(params[:id])
        @order.update!(order_params)
        redirect_to dashboard_order_path(@order)
    end


    def destroy
        @order = Order.find(params[:id])
        @order.destroy
        redirect_to dashboard_orders_path
    end

    private
    def order_params
        params.expect(order: [ :status ])
    end
end
