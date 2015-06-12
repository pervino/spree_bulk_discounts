# SPREE 3-0-stable

# Maybe unneeded

require 'spec_helper'

describe Spree::LineItem, :type => :model do
  let!(:discount) { create(:bulk_discount, :break_points => {"18" => BigDecimal('0.2'), "6" => BigDecimal('0.1'), "12" => BigDecimal('0.15')}) }
  let!(:line_item) { create(:line_item, quantity: 1) }

  before do
    line_item.variant.product.bulk_discount = discount
  end

  it "should not have adjustemtns for invalid quantity" do
    expect(line_item.adjustments.count).to eql 0
  end

  it "should create the line_item adjustments" do
    line_item.quantity = 13
    line_item.save!
    expect(line_item.adjustments.count).to eql 1
  end

end