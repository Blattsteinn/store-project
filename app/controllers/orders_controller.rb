class OrdersController < ApplicationController
    before_action :authenticate_admin!, only: [:destroy]

    def index
        @orders = Order.where(user_id: current_user.id)
    end

    def show
        #add later
    end

    def create
        if session[:cart].blank?
            redirect_to cart_path, alert: "Cart is empty" and return
        end

        cart_items = session[:cart].map do |variant_id, quantity|
                [Variant.find(variant_id), quantity]
        end
        
        # Validate all stock before touching the DB
        cart_items.each do |variant, quantity|
            if variant.stock < quantity
                redirect_to cart_path, alert: "#{variant.title} is out of stock"
                return
            end
        end


        @order = Order.create!(user_id: current_user.id)
        cart_items.each do |variant, quantity|
           product = variant.product
           OrderItem.create!(
                order_id: @order.id,
                product_id: product.id,
                variant_id: variant.id,
                quantity: quantity,
                price: variant.price
            )
            variant.update!(stock: variant.stock - quantity.to_i)
            
        end

        session[:cart] = {}
        redirect_to order_path(@order), notice: "Order created successfully"
    end

    def destroy
        @order = Order.find(params[:id])
        @order.destroy
        redirect_to products_path
    end
end
