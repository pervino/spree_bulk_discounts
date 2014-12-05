# SPREE 2.4
# ENGRAVING FEE MODEL SPEC
#
# encoding: utf-8
#
require 'spec_helper'

describe Spree::BulkDiscount do

  it "is invalid with 0 quantity" do
    FactoryGirl.build(:bulk_discount, :break_points => { "0" => 1}).should_not be_valid
  end

  it "is invalid with a rate over 90%" do
    FactoryGirl.build(:bulk_discount, :break_points => { "1" => 0.91}).should_not be_valid
  end

  it "is invalid with no breakpoints" do
    FactoryGirl.build(:bulk_discount, :break_points => {}).should_not be_valid
  end

  context "bulk discount methods" do

    let!(:discount) { create(:bulk_discount) }
    let!(:line_item) { create(:line_item, quantity: 13) }

    before do
      line_item.variant.product.bulk_discount = discount
    end

    it "should fetch the correct rate" do
      expect(discount.getRate(3)).to eq(0)
      expect(discount.getRate(6)).to eq(0.1)
      expect(discount.getRate(15)).to eq(0.15)
      expect(discount.getRate(30)).to eq(0.2)
    end

    it "should compute the correct percentage rate" do
      expect(discount.compute_amount(line_item)).to eq(-19.5)
    end

    it "should compute the correct flat rate" do
      discount.discount_method = "flat"
      discount.break_points = {"6" => 5, "12" => 20, "18" => 40}
      expect(discount.compute_amount(line_item)).to eq(-20)
    end

  end

  # context "label customization" do
  #
  #   let(:product) { create(:product, bulk_discount: create(:bulk_discount) ) }
  #   let(:variant) { create(:variant, product: product) }
  #
  #   it "does not trigger the bulk discount for low quantity" do
  #     line_item = subject.add(variant, 1)
  #     # 19.99 119.994
  #     expect(line_item.total).to eq(19.99)
  #   end
  #
  #   it "triggers the bulk discount for min quantity" do
  #     line_item = subject.add(variant, 6)
  #     # 0.9 * (19.99 * 6)
  #     expect(line_item.total).to eq(107.946)
  #   end
  #
  #   it "triggers the bulk discount for next quantity" do
  #     line_item = subject.add(variant, 12)
  #     # 0.85 * (19.99 * 12)
  #     expect(line_item.total).to eq(203.898)
  #   end
  # end
end