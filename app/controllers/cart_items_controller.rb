class CartItemsController < ApplicationController

    def create
        @cart_item = CartItem.new(cart_item_params)
        @cart_item.user = current_user

        if @cart_item.save
            redirect_to products_path, notice: "Added to cart"
        else
            redirect_to products_path, alert: "Error adding to cart"
        end
    end

    def destroy
        @cart_item = CartItem.find(params[:id])
        @cart_item.destroy
        redirect_to cart_path, notice: "Removed from cart"
    end

    private
    def cart_item_params
        params.expect(cart_item: [:product_id, :quantity])
    end
end
