class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.string :test
      t.string :read

      t.timestamps
    end
  end
end
