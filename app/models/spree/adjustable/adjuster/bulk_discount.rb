module Spree
  module Adjustable
    module Adjuster
      class BulkDiscount < Spree::Adjustable::Adjuster::Base
        def update
          bulk_discount = adjustments.bulk_discount

          bulk_discount.each do |adj|
            adj.update_column("eligible", true)
          end

          bulk_discount_total = bulk_discount.reload.map(&:update!).compact.sum

          update_totals(bulk_discount_total)
        end

        private

        def adjustments
          adjustable.try(:all_adjustments).try(:eligible) || adjustable.adjustments.try(:eligible)
        end

        def update_totals(bulk_discount_total)
          @totals[:bulk_discount_total] = bulk_discount_total
          @totals[:taxable_adjustment_total] += bulk_discount_total
        end
      end
    end
  end
end
