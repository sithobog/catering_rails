ActiveAdmin.register User do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  permit_params :name, :email, :password, :password_confirmation

    index do
    	column :name
      column :email
      column :current_sign_in_at
      column :last_sign_in_at
      column :sign_in_count
      actions
    end

    filter :email

    form do |f|
      f.inputs "User Details" do
      	f.input :name
        f.input :email
        f.input :password
        f.input :password_confirmation
      end
      f.actions
    end

end
