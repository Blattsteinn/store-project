class ProductsController < ApplicationController
    before_action :authenticate_admin!, only: [:new, :create, :edit, :update, :destroy]

    def index
        @products = Product.visible.includes(:variants, product_images: :image_attachment)
        @products = @products.where("title ILIKE ?", "%#{params[:product_name]}%") if params[:product_name].present?
    end

    def show
        @product = Product.includes(:variants, product_images: :image_attachment).find(params[:id])
    end

    def new
        @product = Product.new
        @product.product_images.build
        @product.variants.build
    end

    def create
        @product = Product.new(product_params)
        if @product.save  
            redirect_to @product
        else
            render :new, status: :unprocessable_entity
        end
    end

    def edit
        @product = Product.find(params[:id])
    end

    def update
        @product = Product.find(params[:id])
        
        if @product.update(product_params) 
            #This is probably not correct
            if @product.previous_changes.any? || @product.saved_changes.any?
                flash[:successful_edit] = "Product successfully edited."
            else
                flash[:successful_edit] = "No changes were made."
            end
            redirect_to dashboard_products_path

        else
            flash.now[:fail_edit]= "Product failed to edit"
            render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        @product = Product.find(params[:id])
        @product.destroy
        redirect_to products_path
    end

    private
    def product_params
        params.expect(product: [:title, :visibility, :description, :payment_type, :deliverables, 
        product_images_attributes: [[:image, :priority, :_destroy, :id]],
        variants_attributes: [[:stock, :price, :title, :description, :_destroy, :id]]
        ])
    end

end
