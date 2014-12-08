module Spree
  class BulkDiscountConfiguration < Preferences::Configuration
    preference :label, :string, :default => 'Bulk Discount'
    preference :max_precent_rate, :double, :default => 0.9
    preference :min_quantity, :integer, :default => 3
  end
end
