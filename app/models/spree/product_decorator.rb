module Spree
  Product.class_eval do
    belongs_to :bulk_discount, :class_name => Spree::BulkDiscount
  end
end
