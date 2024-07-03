class DropTableDeveloperProjects < ActiveRecord::Migration[7.0]
  def change
    drop_table :developers_projects if table_exists?(:developers_projects)
  end
end
