class AddJoinTableDevelopersTasks < ActiveRecord::Migration[7.0]
  def change
    create_join_table :developers, :tasks do |t|
      t.index [:developer_id, :task_id]
      t.index [:task_id, :developer_id]
    end
  end
end
