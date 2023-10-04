class AddLastnameToDevelopers < ActiveRecord::Migration[7.0]
  def change
    add_column :developers, :lastname, :string
  end
end
