class CartsController < ApplicationController
    def show
        if session[:cart].present?
            @cart_items = session[:cart].map do |product_id, quantity|
                [Product.find(product_id), quantity]
            end
        else
            @cart_items = []
        end
    end
end
