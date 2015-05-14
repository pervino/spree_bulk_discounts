module Spree
  LineItem.class_eval do
    after_create :update_bulk_discount

    def update_bulk_discount
      Spree::BulkDiscount.adjust(order, [self])
    end
  end
end
