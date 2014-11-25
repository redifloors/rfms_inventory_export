class AddUpdatedToInventory < ActiveRecord::Migration
  def change
    add_column :inventories, :updated, :boolean, default: false
  end
end
