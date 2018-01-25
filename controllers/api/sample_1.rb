module Api
  module V1
    class ProductsController < Api::ApiBaseController
      authorize_resource

      def show
        run_and_render ::Product::Show, id: params[:id]
      end

      def create
        run_and_render ::Product::Create, params_normalizer.deserialized_params
      end

      def update
        run_and_render ::Product::Update, params_normalizer.deserialized_params
      end

      def destroy
        run_and_render ::Product::Destroy, id: params[:id]
      end
    end
  end
end
