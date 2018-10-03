class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :email, default: ''
      t.string :full_name, default: ''
      t.string :uid, default: '', null: false
      t.string :provider, default: '', null: false
      t.timestamps
    end
  end
end
