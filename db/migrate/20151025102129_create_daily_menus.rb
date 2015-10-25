class CreateDailyMenus < ActiveRecord::Migration
  def change
    create_table :daily_menus do |t|
    	t.integer :day_number
    	t.float :max_total
    	t.integer :dish_ids, array: true, default: []
    	t.timestamps null: false
    end
  end
end
