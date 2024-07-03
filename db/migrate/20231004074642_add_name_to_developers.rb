class AddNameToDevelopers < ActiveRecord::Migration[7.0]
  def change
    add_column :developers, :name, :string
  end
end
