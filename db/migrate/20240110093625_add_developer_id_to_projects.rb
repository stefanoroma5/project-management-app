class AddDeveloperIdToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :developer_id, :integer
  end
end
