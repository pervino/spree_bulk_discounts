# Refactor to do breakpoints better.

module Spree
  class BulkDiscount < ActiveRecord::Base
    include Spree::AdjustmentSource

    acts_as_paranoid
    serialize :break_points, Hash

    has_many :products

    validates_presence_of :break_points, :name
    validate :enforce_breakpoints, on: [:create, :update]

    before_save :set_break_points
    before_update :touch_products
    before_destroy :touch_products

    # Deletes all bulk discount adjustments, then applies all applicable
    # discounts to relevant items
    def self.adjust(order, items)
      # using destroy_all to ensure adjustment destroy callback fires.
      Spree::Adjustment.where(adjustable: items).bulk_discount.destroy_all
      relevant_items = items.select { |item| item.product.bulk_discount.present? }
      relevant_items.each do |item|
        item.variant.product.bulk_discount.adjust(order, item)
      end
    end

    def adjust(order, item)
      create_unique_adjustment(order, item)
    end

    def compute_amount(item)
      -getRate(item.reload.quantity) * item.amount
    end

    def getRate(quantity)
      quantity_key = break_points.keys.sort { |a, b| Integer(a) <=> Integer(b) }.take_while { |k| Integer(k) <= quantity }.last
      BigDecimal(break_points[quantity_key] || 0)
    end

    private

    # TODO put the discount percentage in the label
    def label(amount = nil)
      "Bulk Discount"
    end

    # todo should these be moved to the controller?
    # could use some validation here just if we wanted to be extra careful
    def set_break_points
      parsed_break_points = {}
      break_points.map do |quantity, rate|
        parsed_break_points[Integer(quantity)] = BigDecimal(rate)
      end
      self.break_points = parsed_break_points
    end

    # custom validator
    def enforce_breakpoints
      break_points.map do |quantity, rate|
        if BigDecimal(rate) > Spree::BulkDiscounts::Config.max_percent_rate
          errors.add(:break_points, "Rate cannot be more than #{Spree::BulkDiscounts::Config.max_percent_rate * 100}%")
        end
        if Integer(quantity) < Spree::BulkDiscounts::Config.min_quantity
          errors.add(:break_points, "Quantity must be at least #{Spree::BulkDiscounts::Config.min_quantity}")
        end
      end
    end

    def touch_products
      products.each(&:touch)
    end
  end
end