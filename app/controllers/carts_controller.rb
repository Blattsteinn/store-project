class CartsController < ApplicationController
    def show
        @cart_items = current_user.cart_items
    end
    
end
