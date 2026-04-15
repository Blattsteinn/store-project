class CartItemsController < ApplicationController
    def create
        product  = Product.find(params[:product_id])
        quantity = params[:quantity].to_i

        return if product.stock < 1

        product_id = product.id.to_s
        session[:cart] ||= {}

        if session[:cart][product_id].present?
            total = session[:cart][product_id].to_i + quantity
            session[:cart][product_id] = total unless total > product.stock
        else
            session[:cart][product_id] = quantity
        end

        redirect_to products_path, notice: "Added to cart"
    end

    def update
        product = Product.find(params[:product_id])
        quantity = params[:quantity].to_i

        if quantity < 1 || quantity > product.stock
            return redirect_to cart_path
        end

        session[:cart][params[:product_id].to_s] = quantity
        redirect_to cart_path
    end

    def destroy
        session[:cart].delete(params[:product_id].to_s)
        redirect_to cart_path, notice: "Removed from cart"
    end
end
