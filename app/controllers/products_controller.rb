class ProductsController < ApplicationController
    before_action :authenticate_admin!, except: [:index, :show]

    def index
        @products = Product.visible.includes(:variants, product_images: :image_attachment)
        @products = @products.where("title ILIKE ?", "%#{params[:product_name]}%") if params[:product_name].present?
    end

    def show
        @product = Product.includes(:variants, product_images: :image_attachment).find(params[:id])
        unless @product.visibility == "live"
            redirect_to products_path
        end
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
        @product = Product.includes(:variants, product_images: :image_attachment).find(params[:id])
    end

    def update
        @product = Product.find(params[:id])
        @product.assign_attributes(product_params)

        has_changes = @product.changed? || @product.variants.any?(&:changed?) || @product.product_images.any?(&:changed?)


        if has_changes
            if @product.save
                flash[:successful_edit] = "Saved succesfully."
                redirect_to dashboard_products_path
            else
                flash.now[:fail_edit] = "Failed to save succesfully."
                render :edit, status: :unprocessable_entity
            end
        else
            flash[:successful_edit] = "No changes were made."
            redirect_to dashboard_products_path
        end
    end


    def product_visibility
        @product = Product.find(params[:id])
        new_visibility = @product.visibility == "live" ? "hidden" : "live"
        @product.update!(visibility: new_visibility)
        redirect_to dashboard_products_path
    end

    def duplicate_product
        @original_p = Product.includes(:variants).find(params[:id])
        @original_v = @original_p.variants

        @product = Product.create!(@original_p.attributes.except("id","created_at","updated_at"))
        @product.update!(title: @product.title + " Copy")
        @original_v.each do |variant|
            v = Variant.create!(variant.attributes.except("id", "created_at","updated_at"))
            v.update!(product_id: @product.id)
        end

        redirect_to edit_product_path(@product)
    end

    def destroy
        @product = Product.find(params[:id])
        title = @product.title
        @product.destroy!
        flash[:notice] = "\"#{title}\" deleted — existing orders preserved."
        redirect_to dashboard_products_path
    end

    private
    def product_params
        params.expect(product: [:title, :visibility, :description, :payment_type, :deliverables, 
        product_images_attributes: [[:image, :priority, :_destroy, :id]],
        variants_attributes: [[:stock, :price, :title, :description, :_destroy, :id]]
        ])
    end

end
