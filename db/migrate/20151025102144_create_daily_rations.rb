class CreateDailyRations < ActiveRecord::Migration
  def change
    create_table :daily_rations do |t|
    	t.float :price
    	t.integer :quantity
    	#t.reference :person
    	t.references :daily_menu
    	t.references :sprint
    	t.references :dish
      t.timestamps null: false
    end

    #add_index :daily_rations, :person_id
    add_index :daily_rations, :daily_menu_id
    add_index :daily_rations, :sprint_id
    add_index :daily_rations, :dish_id
    
  end
end
