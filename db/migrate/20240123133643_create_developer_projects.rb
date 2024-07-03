class CreateDeveloperProjects < ActiveRecord::Migration[7.0]
  def change
    create_table :developer_projects do |t|
      t.references :developer, null: false, foreign_key: true
      t.references :project, null: false, foreign_key: true

      t.timestamps
    end
  end
end
