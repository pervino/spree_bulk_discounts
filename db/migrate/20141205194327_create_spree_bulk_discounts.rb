class CreateSpreeBulkDiscounts < ActiveRecord::Migration
  def change
    enable_extension 'hstore'

    create_table :spree_bulk_discounts do |t|
      t.string :name
      t.string :label
      t.string :discount_method
      t.hstore :break_points

      t.datetime :deleted_at
      t.timestamps
    end
  end
end
