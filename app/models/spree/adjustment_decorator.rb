module Spree
  Adjustment.class_eval do
    scope :bulk_discount, -> { where(source_type: 'Spree::BulkDiscount') }

    def bulk_discount?
      source_type == 'Spree::BulkDiscount'
    end
  end
end