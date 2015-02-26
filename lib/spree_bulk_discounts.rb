require 'spree_core'

module Spree
  module BulkDiscount
    def self.config(&block)
      yield(Spree::BulkDiscount::Config)
    end
  end
end

require 'spree_bulk_discounts/engine'
