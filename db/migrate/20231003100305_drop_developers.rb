class DropDevelopers < ActiveRecord::Migration[7.0]
  def change
    drop_table :developers
  end
end
