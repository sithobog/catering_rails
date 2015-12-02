ActiveAdmin.register Sprint do

  permit_params :title, :started_at, :finished_at, :state

  show do
    all_users = User.all.count.to_f
    user_with_order = User.with_rations(sprint.id).count.to_f
    percent = ((user_with_order/all_users)*100).round(1)
    h2 class: "bar-title" do "Completed orders in sprint" end
    div class: "progress progress-striped active" do
        span class: "percent" do
          "#{percent}%"
        end
      div class: "progress-bar", style: "width: #{percent}%;" do
      end
    end
    default_main_content
  end

  # Show users who have rations in sprint
  sidebar 'Already ordered ', only: :show do
    table_for User.with_rations(sprint.id) do
      column 'Name' do |user|
        link_to user.name, admin_user_path(user)
      end
      column 'Email' do |user|
        link_to user.email, admin_user_path(user)
      end
    end
  end

  # Show all users who dont have rations in sprint
  sidebar "Not ordered yet", only: :show do
    table_for User.without_rations(sprint.id) do
      column 'Name' do |user|
        link_to user.name, admin_user_path(user)
      end
      column 'Email' do |user|
        link_to user.email, admin_user_path(user)
      end
    end
  end


  form do |f|
    f.inputs "Daily Ration" do
      f.input :title
      f.input :started_at
      f.input :finished_at
      f.input :state, as: :select, collection: ["pending", "running", "closed"]
    end
    f.actions
  end
end
