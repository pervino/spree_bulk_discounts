FactoryGirl.define do

  factory :bulk_discount, class: Spree::BulkDiscount do
    name "tacos (bulk)"
    label "nachos"
    discount_method "percent"
    break_points { {"6" => 0.1, "12" => 0.15, "18" => 0.2} }
  end

end