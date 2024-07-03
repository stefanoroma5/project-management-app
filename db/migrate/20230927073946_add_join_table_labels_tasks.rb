class AddJoinTableLabelsTasks < ActiveRecord::Migration[7.0]
  def change
    create_join_table :labels, :tasks do |t|
      t.index [:label_id, :task_id]
      t.index [:task_id, :label_id]
    end
  end
end
