require 'spree_core'

module Spree
  module BulkDiscounts
    def self.config(&block)
      yield(Spree::BulkDiscounts::Config)
    end
  end
end

require 'spree_bulk_discounts/engine'
