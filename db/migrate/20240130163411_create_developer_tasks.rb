class CreateDeveloperTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :developer_tasks do |t|
      t.references :developer, null: false, foreign_key: true
      t.references :task, null: false, foreign_key: true

      t.timestamps
    end
  end
end
