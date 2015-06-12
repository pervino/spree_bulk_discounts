module Spree
  LineItem.class_eval do
    after_save :update_bulk_discount

    # This is more spree like because spree only recalculates
    # adjustments if the quantity is updated and on save.
    # Plus this also works on update.
    def update_bulk_discount
      if quantity_changed?
        Spree::BulkDiscount.adjust(order, [self])
      end
    end
  end
end
