class AddBulkDiscountToProduct < ActiveRecord::Migration
  def change
    add_column :spree_products, :bulk_discount_id, :integer
  end
end
