class AddBulkDiscountTotals < ActiveRecord::Migration
  def change
    add_column :spree_orders, :bulk_discount_total, :decimal, precision: 10, scale: 2, default: 0.0
    add_column :spree_line_items, :bulk_discount_total, :decimal, precision: 10, scale: 2, default: 0.0
    add_column :spree_shipments, :bulk_discount_total, :decimal, precision: 10, scale: 2, default: 0.0
  end
end
