module Spree
  LineItem.class_eval do
    after_save :update_bulk_discount

    # note this causes a double update when quantity is changed
    def update_bulk_discount
      if quantity_changed?
        Spree::BulkDiscount.adjust(order, [self])
      end
    end
  end
end
