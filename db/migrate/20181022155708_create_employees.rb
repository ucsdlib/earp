class CreateEmployees < ActiveRecord::Migration[5.2]
  def change
    create_table :employees do |t|
      t.string :uid, null: false
      t.string :name, null: false
      t.string :manager, null: false
      t.string :email, null: false
      t.string :display_name, null: false

      t.timestamps
    end
  end
end
