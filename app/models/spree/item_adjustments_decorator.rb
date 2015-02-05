Spree::ItemAdjustments.class_eval do

  # TODO refactor the bulk discount decision into choose_best_promotion_adjustment
  def update_adjustments
    bulk_discount_total = 0
    bulk_discount_total = adjustments.bulk_discount.reload.map(&:update!).compact.sum

    promo_total = 0
    run_callbacks :promo_adjustments do
      promotion_total = adjustments.promotion.reload.map(&:update!).compact.sum
      unless promotion_total == 0
        choose_best_promotion_adjustment
      end
      promo_total = best_promotion_adjustment.try(:amount).to_f
    end

    ###
    if bulk_discount_total < promo_total
      promo_total = 0
      adjustments.promotion.update_all(eligible: false)
    else
      bulk_discount_total = 0
      adjustments.bulk_discount.update_all(eligible: false)
    end
    ###

    included_tax_total = 0
    additional_tax_total = 0
    run_callbacks :tax_adjustments do
      tax = (item.respond_to?(:all_adjustments) ? item.all_adjustments : item.adjustments).tax
      included_tax_total = tax.is_included.reload.map(&:update!).compact.sum
      additional_tax_total = tax.additional.reload.map(&:update!).compact.sum
    end


    item.update_columns(
        :promo_total => promo_total,
        :included_tax_total => included_tax_total,
        :additional_tax_total => additional_tax_total,
        :bulk_discount_total => bulk_discount_total,
        :adjustment_total => promo_total + additional_tax_total + bulk_discount_total,
        :updated_at => Time.now
    )
  end

end