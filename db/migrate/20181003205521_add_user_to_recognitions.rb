class AddUserToRecognitions < ActiveRecord::Migration[5.2]
  def change
    add_reference :recognitions, :user, foreign_key: true
  end
end
