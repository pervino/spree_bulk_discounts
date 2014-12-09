class CreateSpreeBulkDiscounts < ActiveRecord::Migration
  def change
    create_table :spree_bulk_discounts do |t|
      t.string :name
      t.string :discount_method
      t.text :break_points

      t.datetime :deleted_at
      t.timestamps
    end
  end
end
