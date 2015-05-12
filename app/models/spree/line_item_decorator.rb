module Spree
  LineItem.class_eval do

    after_save :update_bulk_discount

    def update_bulk_discount
      if quantity_changed?
        Spree::BulkDiscount.adjust(self)
      end
    end
  end
end
