module Api
  module V1
    class CategoriesController < BaseController
      before_action :set_category, only: %i[show update destroy]

      def index
        @categories = Category.all
        render json: @categories
      end

      def show
        render json: @category
      end

      def create
        @category = Category.new(category_params)
        if @category.save
          render json: @category, status: :created
        else
          render json: { errors: @category.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @category.update(category_params)
          render json: @category
        else
          render json: { errors: @category.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        if @category.products.exists?
          render json: { error: 'Cannot delete category with active products' }, status: :bad_request
        else
          @category.destroy
          head :no_content
        end
      end

      private

      def set_category
        @category = Category.find(params[:id])
      end

      def category_params
        params.require(:category).permit(:name, :publish)
      end
    end
  end
end
