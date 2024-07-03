class AddEmailToDeveloperProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :developer_projects, :email, :string
  end
end
