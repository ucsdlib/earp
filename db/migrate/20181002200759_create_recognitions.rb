class CreateRecognitions < ActiveRecord::Migration[5.2]
  def change
    create_table :recognitions do |t|
      t.string :recognizee, null: false
      t.string :library_value, null: false
      t.text :description, null: false
      t.boolean :anonymous, default: false
      t.string :recognizer

      t.timestamps
    end
  end
end
