# Extension using spree recommended overrides for ruby 2.1
# more info at http://guides.spreecommerce.com/developer/logic.html

# Spree 2.4.0 Extension - sexy

module ItemAdjustmentsExtensions

  def update_adjustments
    super
    update_bulk_discount_adjustments
  end

  def update_bulk_discount_adjustments
    bulk_discount_total = adjustments.bulk_discount.reload.map do |adjustment|
      adjustment.update!(item)
    end.compact.sum

    item.update_columns(
        :bulk_discount_total => bulk_discount_total,
        :adjustment_total => item.adjustment_total + bulk_discount_total,
    )
  end

end

Spree::ItemAdjustments.class_eval do

  set_callback :promo_adjustments, :after do
    promo_total = best_promotion_adjustment.try(:amount).to_f
    bulk_discount_total = adjustments.bulk_discount.reload.map(&:update!).compact.sum

    # Only allow bulk shipping discount if it is better than the promotion
    if bulk_discount_total < promo_total
      adjustments.promotion.update_all(eligible: false)
    else
      adjustments.bulk_discount.update_all(eligible: false)
    end
  end

  prepend ItemAdjustmentsExtensions
end