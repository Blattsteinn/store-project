class CartItemsController < ApplicationController
    def create
        variant  = Variant.find(params[:variant_id])
        quantity = params[:quantity].to_i

        return if variant.stock < 1

        session[:cart] ||= {}
        # Hash structure
        # variant_id => quantitiy,

        if session[:cart][variant.id.to_s].present?  
            total = session[:cart][variant.id.to_s].to_i + quantity
            session[:cart][variant.id.to_s] = total unless total > variant.stock
        else
            session[:cart][variant.id.to_s] = quantity unless quantity > variant.stock
        end
        redirect_to products_path, notice: "Added to cart"
    end

    def update
        variant = Variant.find(params[:variant_id])
        quantity = params[:quantity].to_i

        if quantity < 1 || quantity > variant.stock
            return 
            redirect_to cart_path
        end

        session[:cart][params[:variant_id].to_s] = quantity
        redirect_to cart_path
    end

    def destroy
        session[:cart].delete(params[:variant_id].to_s)
        redirect_to cart_path, notice: "Removed from cart"
    end
end
