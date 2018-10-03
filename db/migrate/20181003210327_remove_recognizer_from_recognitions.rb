class RemoveRecognizerFromRecognitions < ActiveRecord::Migration[5.2]
  def change
    remove_column :recognitions, :recognizer, :string
  end
end
