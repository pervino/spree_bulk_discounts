# require 'spec_helper'
#
# module Spree
#   describe ItemAdjustments, :type => :model do
#     let(:order) { create :order_with_line_items, line_items_count: 1 }
#     let(:line_item) { order.line_items.first }
#
#     let(:subject) { ItemAdjustments.new(line_item) }
#     let(:order_subject) { ItemAdjustments.new(order) }
#
#     def create_adjustment(label, amount)
#       create(:adjustment, :order => order,
#              :adjustable => line_item,
#              :source => source,
#              :amount => amount,
#              :state => "closed",
#              :label => label,
#              :mandatory => false)
#     end
#
#     context "best promotion is always applied" do
#       let(:bulk_discount) { create(:bulk_discount) }
#
#       let(:calculator) { Calculator::FlatRate.new(:preferred_amount => 10) }
#
#       let(:source) { Promotion::Actions::CreateItemAdjustments.create calculator: calculator }
#
#       before do
#         line_item.variant.product.bulk_discount = bulk_discount
#         line_item.variant.product.save!
#
#         line_item.quantity += 9
#         line_item.save!
#
#         order.reload
#       end
#
#       it "should take the bulk discount over a promotion" do
#         create_adjustment("Promotion A", -5)
#         line_item.adjustments.each { |a| a.update_column(:eligible, true) }
#
#         subject.update_adjustments
#
#         # no eligible adjustments because bulk discount provides a better offer
#         expect(line_item.adjustments.promotion.eligible.count).to eq(0)
#         expect(line_item.adjustments.eligible.first.source_type).to eq("Spree::BulkDiscount")
#       end
#
#       it "should take the promotion over bulk discount" do
#         create_adjustment("Promotion A", -15)
#         line_item.adjustments.each { |a| a.update_column(:eligible, true) }
#
#         subject.update_adjustments
#
#         expect(line_item.adjustments.promotion.eligible.count).to eq(1)
#         expect(line_item.adjustments.eligible.first.label).to eq("Promotion A")
#       end
#
#     end
#   end
# end
