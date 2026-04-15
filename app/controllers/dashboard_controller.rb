class DashboardController < ApplicationController
    before_action :authenticate_admin!

    def index
        
    end

    def products_view
        @products = Product.all
    end

    def product_view
        @product = Product.find(params[:id])
    end


end
