class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.date :start_date
      t.date :end_date
      t.string :state
      t.string :description
      t.string :task_type
      t.integer :estimation
      t.string :priority
      t.string :title
      t.belongs_to :project, foreign_key: true

      t.timestamps
    end
  end
end
