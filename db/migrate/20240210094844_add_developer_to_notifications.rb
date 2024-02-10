class AddDeveloperToNotifications < ActiveRecord::Migration[7.0]
  def change
    add_reference :notifications, :developer, null: false, foreign_key: true
  end
end
