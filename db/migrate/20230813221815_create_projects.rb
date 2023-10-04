class CreateProjects < ActiveRecord::Migration[7.0]
  def change
    create_table :projects do |t|
      t.string :title
      t.date :deadline
      t.string :customer
      t.string :description
      t.date :start_date
      t.date :end_date
      t.belongs_to :developer, foreign_key: true

      t.timestamps
    end
  end
end
