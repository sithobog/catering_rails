class CreateDishes < ActiveRecord::Migration
  def change
    create_table :dishes do |t|
    	t.string :title
    	t.integer :sort_order
    	t.text :description
    	t.float :price
    	t.string :type
    	t.integer :children_ids, array: true, default: []
      t.references :category
      t.timestamps null: false
    end
  end
end
