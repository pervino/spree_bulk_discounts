FactoryGirl.define do

  factory :bulk_discount, class: Spree::BulkDiscount do
    name "tacos (bulk)"
    label "nachos"
    discount_method "percent"
    break_points { {"6" => BigDecimal('0.1'), "12" => BigDecimal('0.15'), "18" => BigDecimal('0.2')} }
  end

end