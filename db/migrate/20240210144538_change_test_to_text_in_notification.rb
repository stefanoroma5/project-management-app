class ChangeTestToTextInNotification < ActiveRecord::Migration[7.0]
  def change
    rename_column :notification, :test, :text
  end
end
