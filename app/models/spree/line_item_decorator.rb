
module LineItemExtensions

  def update_adjustments
    if quantity_changed?
      update_bulk_discount
    end

    super
  end

  private

  def update_bulk_discount
    Spree::BulkDiscount.adjust(self)
  end

end

module Spree
  LineItem.class_eval do

    after_create :update_bulk_discount

    prepend LineItemExtensions
  end
end
