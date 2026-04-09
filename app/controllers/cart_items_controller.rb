class CartItemsController < ApplicationController
    def create
        product_id =  params[:product_id].to_s
        quantity   =  params[:quantity].to_i

        product_stock = Product.find(product_id.to_i).stock
        if product_stock < 1
            return
        end

        session[:cart] ||= {}
        if session[:cart][product_id].present?
            total = session[:cart][product_id].to_i + quantity
            unless total > product_stock
                session[:cart][product_id] = total
            end
        else
            session[:cart][product_id] = quantity 
        end
        
        redirect_to products_path, notice: "Added to cart"

    end

    def update
        product_stock = Product.find(params[:product_id]).stock
        if params[:quantity].to_i > product_stock || params[:quantity].to_i < 1
            return
        end

        session[:cart][params[:product_id]] = params[:quantity]
        redirect_to cart_path

    end

    def destroy
        product_id = params[:product_id].to_s
        session[:cart].delete(product_id)
        redirect_to cart_path, notice: "Removed from cart"
    end

    private

    def check_stock
        
    end
end
