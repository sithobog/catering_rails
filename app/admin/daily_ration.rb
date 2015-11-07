ActiveAdmin.register DailyRation do

  permit_params :price, :quantity, :daily_menu_id, :sprint_id,
                :dish_id, :user_id

  index do
    selectable_column
    id_column
    column :price
    column :quantity
    column :user_id
    column :dish_id
    column :sprint_id
    column :daily_menu_id
    actions
  end


  form do |f|
    f.inputs "Daily Ration" do
      f.input :price
      f.input :quantity
      f.input :user_id, as: :select, collection: User.all
      f.input :dish_id, as: :select, collection: Dish.all
      f.input :sprint_id, as: :select, collection: Sprint.all
      f.input :daily_menu_id, as: :select, collection: DailyMenu.all
    end
    f.actions
  end
end
