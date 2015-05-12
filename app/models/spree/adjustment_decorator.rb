module Spree
  Adjustment.class_eval do
    scope :bulk_discount, -> { where(source_type: 'Spree::BulkDiscount') }

    self.competing_promos_source_types << 'Spree::BulkDiscount'
  end
end