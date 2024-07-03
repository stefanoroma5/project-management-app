class DropTableLabelsTasks < ActiveRecord::Migration[7.0]
  def change
    drop_table :labels_tasks if table_exists?(:labels_tasks)
  end
end
