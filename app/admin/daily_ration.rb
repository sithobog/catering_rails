ActiveAdmin.register DailyRation do

  permit_params :price, :quantity, :daily_menu_id, :sprint_id,
                :dish_id #:person_id

  form do |f|
    f.inputs "Daily Ration" do
      f.input :price
      f.input :quantity
      #f.input :person_id, as: :select, collection: Person.all
      f.input :dish_id, as: :select, collection: Dish.all
      f.input :sprint_id, as: :select, collection: Sprint.all
      f.input :daily_menu_id, as: :select, collection: DailyMenu.all
    end
    f.actions
  end
end
