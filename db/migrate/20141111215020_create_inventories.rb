class CreateInventories < ActiveRecord::Migration
  def change
    create_table :inventories do |t|
      t.integer :code, index: true
      t.string  :roll
      t.integer :width
      t.integer :feet
      t.integer :inches
      t.integer :store, index: true

      t.timestamps
    end
  end
end
