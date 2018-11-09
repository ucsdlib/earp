class AddSuppressedToRecognitions < ActiveRecord::Migration[5.2]
  def change
    add_column :recognitions, :suppressed, :bool, default: false
  end
end
