class RenameStateToStatusInTasks < ActiveRecord::Migration[7.0]
  def change
    rename_column :tasks, :state, :status
  end
end
