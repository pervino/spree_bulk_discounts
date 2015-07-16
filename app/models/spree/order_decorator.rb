module Spree
  Order.class_eval do

    def display_bulk_discount_total
      Spree::Money.new(bulk_discount_total, {currency: currency})
    end

    def persist_bulk_discount_totals
      total =line_item_adjustments.bulk_discount.eligible.sum(:amount) || 0
      update_columns(
          bulk_discount_total: total,
          updated_at: Time.now
      )
    end

  end
end