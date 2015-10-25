ActiveAdmin.register BusinessLunch do

  permit_params :title, :description, :price, children_ids: []

  form do |f|
    f.inputs "Business Lunch" do
      f.input :title
      f.input :description, as: :text, required: false
      f.input :price
      f.input :children_ids, as: :select, input_html: { :multiple => true },
                             collection: SingleMeal.all
    end
    f.actions
  end

end
