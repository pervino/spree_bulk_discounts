module Spree
  module Adjustable
    module Adjuster
      class BulkDiscount < Spree::Adjustable::Adjuster::Base
        def update
          bulk_discount_total = adjustable.adjustments.bulk_discount.reload.map do |adjustment|
            adjustment.update!(adjustable)
          end.compact.sum

          update_totals(bulk_discount_total)
        end

        private

        def line_item?
          @adjustable.is_a? Spree::LineIitem
        end

        def update_totals(bulk_discount_total)
          # we DO NOT update the adjustment_total since bulk_discount is registered as a competing_promo
          # this is also why we do not register this as a price modifier hook
          @totals[:bulk_discount_total] = bulk_discount_total
        end
      end
    end
  end
end
