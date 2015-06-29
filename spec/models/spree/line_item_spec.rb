require 'spec_helper'

describe Spree::LineItem, :type => :model do
  let!(:discount) { create(:bulk_discount, :break_points => {"18" => BigDecimal('0.2'), "6" => BigDecimal('0.1'), "12" => BigDecimal('0.15')}) }
  let!(:line_item) { create(:line_item, quantity: 1, product: create(:product, bulk_discount: discount)) }

  it "should not have adjustemtns for invalid quantity" do
    expect(line_item.adjustments.count).to eql 0
  end

  describe "creates the adjustments" do
    it "on initial create" do
      new_line_item = create(:line_item, quantity: 13, product: line_item.product)
      expect(new_line_item.adjustments.count).to eql 1
      expect(new_line_item.discounted_amount).to eql 110.5
      expect(new_line_item.bulk_discount_total).to eql -19.5
    end

    it "when updating the quantity" do
      line_item.quantity = 13
      line_item.save!
      expect(line_item.adjustments.count).to eql 1
      expect(line_item.discounted_amount).to eql 110.5
      expect(line_item.bulk_discount_total).to eql -19.5
    end
  end
end