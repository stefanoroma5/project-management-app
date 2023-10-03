class DropDevelopersTask < ActiveRecord::Migration[7.0]
  def change
    drop_table :developers_tasks
  end
end
