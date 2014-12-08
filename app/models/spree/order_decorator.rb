module Spree
  Order.class_eval do

    def bulk_discount_total
      line_item_adjustments.bulk_discount.eligible.sum(:amount) || 0
    end

    def display_bulk_discount_total
      Spree::Money.new(bulk_discount_total, {currency: currency})
    end

  end
end