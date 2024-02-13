class ChangeReadInBoolean < ActiveRecord::Migration[7.0]
  def change
    change_column :notifications, :read, :boolean
  end
end
