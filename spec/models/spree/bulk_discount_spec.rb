# SPREE 2.4
# ENGRAVING FEE MODEL SPEC
#
# encoding: utf-8
#
require 'spec_helper'

describe Spree::BulkDiscount do

  it "is invalid with 0 quantity" do
    FactoryGirl.build(:bulk_discount, :break_points => { "0" => BigDecimal('1')}).should_not be_valid
  end

  it "is invalid with a rate over 90%" do
    FactoryGirl.build(:bulk_discount, :break_points => { "1" => BigDecimal('0.91')}).should_not be_valid
  end

  it "is invalid with no breakpoints" do
    FactoryGirl.build(:bulk_discount, :break_points => {}).should_not be_valid
  end

  context "bulk discount methods" do

    let!(:discount) { create(:bulk_discount, :break_points => {"18" => BigDecimal('0.2'), "6" => BigDecimal('0.1'), "12" => BigDecimal('0.15')}) }
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
end