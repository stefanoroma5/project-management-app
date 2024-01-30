class DropTableDevelopersTasks < ActiveRecord::Migration[7.0]
  def change 
    drop_table :developers_tasks if table_exists?(:developers_tasks)
  end
end