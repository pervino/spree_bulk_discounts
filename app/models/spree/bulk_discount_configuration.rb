module Spree
  class BulkDiscountConfiguration < Preferences::Configuration
    # Default max percent for breakpoints
    preference :max_percent_rate, :double, :default => 0.9

    # Default in quantity for base breakpoint
    preference :min_quantity, :integer, :default => 2
  end
end
