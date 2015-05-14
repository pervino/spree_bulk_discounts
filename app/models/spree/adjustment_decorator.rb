module Spree
  Adjustment.class_eval do
    scope :bulk_discount, -> { where(source_type: 'Spree::BulkDiscount') }

    # TODO let's move configuration like this to engine
    self.competing_promos_source_types << 'Spree::BulkDiscount'
  end
end