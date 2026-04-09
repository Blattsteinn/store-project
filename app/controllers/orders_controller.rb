class OrdersController < ApplicationController

    def index
        @orders = Order.where(user_id: current_user.id)
    end


    def create
        if session[:cart].blank?
            redirect_to cart_path, alert: "Cart is empty" and return
        end

        #recheck stock here.

        #["id", "created_at", "updated_at", "order_id", "product_id", "quantity", "price"]
        @order = Order.create!(user_id: current_user.id)
        session[:cart].each do |product_id, quantity|
           product = Product.find(product_id)
           OrderItem.create!(
                order_id: @order.id,
                product_id: product_id,
                quantity: quantity,
                price: product.pricing
            )

            product.update!(stock: product.stock - quantity.to_i)
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
