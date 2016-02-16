module Spree
  module Adjustable
    module Adjuster
      class BulkDiscount < Spree::Adjustable::Adjuster::Base
        def update
          adjustable.adjustments.bulk_discount.reload.map do |adjustment|
            adjustment.update_column("eligible", true)
            adjustment.update!(adjustable)
          end
          bulk_discount_total = adjustable.adjustments.bulk_discount.reload.eligible.sum(:amount)

          update_totals(bulk_discount_total)
        end

        private

        def line_item?
          @adjustable.is_a? Spree::LineIitem
        end

        def update_totals(bulk_discount_total)
          @totals[:bulk_discount_total] = bulk_discount_total
          @totals[:taxable_adjustment_total] += bulk_discount_total
        end
      end
    end
  end
end
