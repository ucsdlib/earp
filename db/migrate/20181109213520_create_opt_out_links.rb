class CreateOptOutLinks < ActiveRecord::Migration[5.2]
  def change
    create_table :opt_out_links do |t|
      t.string :key, null: false
      t.bigint :recognition_id, null: false
      t.datetime :expires, null: false

      t.timestamps
    end
  end
end
