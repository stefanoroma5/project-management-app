class AddStatusToDeveloperProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :developer_projects, :status, :string
  end
end
