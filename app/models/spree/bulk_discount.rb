# Refactor to do breakpoints better.

module Spree
  class BulkDiscount < ActiveRecord::Base
    acts_as_paranoid
    serialize :break_points, Hash

    has_many :adjustments, as: :source, dependent: :destroy
    has_many :products

    validates_presence_of :break_points, :name
    validate :enforce_breakpoints, on: [:create, :update]

    before_save :set_break_points

    def self.adjust(order, items)
      items.each do |item|
        next unless item.instance_of?(Spree::LineItem) && item.variant.product.bulk_discount

        item.adjustments.bulk_discount.delete_all
        item.variant.product.bulk_discount.adjust(order, item)
      end
    end

    def adjust(order, item)
      amount = compute_amount(item)
      return if amount == 0

      self.adjustments.create!({
                                   adjustable: item,
                                   eligible: true,
                                   amount: amount,
                                   order_id: item.order_id,
                                   label: name,
                                   included: false
                               })
    end

    def compute_amount(item)
      -getRate(item.quantity) * item.amount
    end


    def getRate(quantity)
      quantity_key = break_points.keys.sort {|a, b| Integer(a) <=> Integer(b) }.take_while { |k| Integer(k) <= quantity }.last
      BigDecimal(break_points[quantity_key] || 0)
    end

    private

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
        if BigDecimal(rate) > Spree::BulkDiscount::Config.max_percent_rate
          errors.add(:break_points, "Rate cannot be more than #{Spree::BulkDiscount::Config.max_percent_rate * 100}%")
        end
        if Integer(quantity) < Spree::BulkDiscount::Config.min_quantity
          errors.add(:break_points, "Quantity must be at least #{Spree::BulkDiscount::Config.min_quantity}")
        end
      end
    end
  end
end