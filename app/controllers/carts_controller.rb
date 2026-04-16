class CartsController < ApplicationController
    def show
        if session[:cart].present?
            @cart_items = session[:cart].map do |variant_id, quantity|
                [Variant.find(variant_id), quantity]
            end
        else
            @cart_items = []
        end
    end
end
