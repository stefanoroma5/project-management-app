class CreateDevelopers < ActiveRecord::Migration[7.0]
  def change
    create_table :developers do |t|
      t.string :name
      t.string :lastname
      t.string :email
      t.string :password

      t.timestamps
    end
  end
end
