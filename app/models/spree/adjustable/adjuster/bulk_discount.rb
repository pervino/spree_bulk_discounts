module Spree
  module Adjustable
    module Adjuster
      class BulkDiscount < Spree::Adjustable::Adjuster::Base
        def update
          return unless adjustable === "Spree::LineItem"

          bulk_discount = adjustments.bulk_discount

          bulk_discount.each do |adj|
            adj.update_column("eligible", true)
          end

          bulk_discount_adjustments = adjustments.competing_promos.reload.map { |a| a.update!(adjustable) }
          bulk_discounts_total = bulk_discount_adjustments.compact.sum
          choose_best_promo_adjustment unless bulk_discount_adjustments == 0
          bulk_discount_total = best_promo_adjustment.try(:amount).to_f if best_promo_adjustment.try(:bulk_discount?)

          update_totals(bulk_discount_total)
        end

        private

        # Picks one (and only one) competing discount to be eligible for
        # this order. This adjustment provides the most discount, and if
        # two adjustments have the same amount, then it will pick the
        # latest one.
        def choose_best_promo_adjustment
          if best_promo_adjustment
            other_promotions = adjustments.competing_promos.where.not(id: best_promo_adjustment.id)
            other_promotions.update_all(eligible: false)
          end
        end

        def best_promo_adjustment
          @best_promo_adjustment ||= begin
            adjustments.competing_promos.eligible.reorder("amount ASC, created_at DESC, id DESC").first
          end
        end

        def adjustments
          adjustable.try(:all_adjustments) || adjustable.adjustments
        end

        def update_totals(bulk_discount_total)
          bulk_discount_total ||= 0
          @totals[:bulk_discount_total] = bulk_discount_total
          @totals[:taxable_adjustment_total] += bulk_discount_total
        end
      end
    end
  end
end
