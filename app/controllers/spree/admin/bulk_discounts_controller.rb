module Spree
  module Admin
    class BulkDiscountsController < ResourceController

      def new_break_point
        @bulk_discount = Spree::BulkDiscount.find(params[:id])
      end

    end
  end
end