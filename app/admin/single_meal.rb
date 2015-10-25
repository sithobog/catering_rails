ActiveAdmin.register SingleMeal do

  permit_params :title, :description, :price, :category_id, :data

  form(:html => { :multipart => true }) do |f|
    f.inputs "Meal" do
      f.input :title
      f.input :description, as: :text, required: false
      f.input :price
      f.input :category, as: :select, collection: Category.all
    end
    f.actions
  end
end
