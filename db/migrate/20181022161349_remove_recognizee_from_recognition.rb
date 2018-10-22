class RemoveRecognizeeFromRecognition < ActiveRecord::Migration[5.2]
  def change
    remove_column :recognitions, :recognizee, :string
  end
end
