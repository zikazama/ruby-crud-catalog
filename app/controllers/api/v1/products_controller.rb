module Api
  module V1
    class ProductsController < BaseController
      before_action :set_product, only: %i[show update destroy]

      def index
        @products = Product.includes(:category).all
        render json: @products.as_json(include: { category: { only: [:id, :name] } })
      end

      def show
        render json: @product.as_json(include: :category)
      end

      def create
        @product = Product.new(product_params)
        if @product.save
          render json: @product, status: :created
        else
          render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @product.update(product_params)
          render json: @product
        else
          render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @product.destroy
        head :no_content
      end

      def export
        products = Product.includes(:category).all
        
        package = Axlsx::Package.new
        workbook = package.workbook
        workbook.add_worksheet(name: 'Products') do |sheet|
          sheet.add_row ['ID', 'Name', 'Category', 'Publish']
          products.each do |product|
            sheet.add_row [
              product.id,
              product.name,
              product.category&.name,
              product.publish == 'yes' ? 'Yes' : 'No'
            ]
          end
        end
        
        send_data package.to_stream.read, 
                  filename: 'products.xlsx',
                  type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
      end

      private

      def set_product
        @product = Product.find(params[:id])
      end

      def product_params
        params.require(:product).permit(:name, :category_id, :publish)
      end
    end
  end
end
