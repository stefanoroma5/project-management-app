class DropDevelopersProject < ActiveRecord::Migration[7.0]
  def change
    drop_table :developers_projects
  end
end
