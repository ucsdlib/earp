class AddEmployeeRefToRecognition < ActiveRecord::Migration[5.2]
  def change
    add_reference :recognitions, :employee, foreign_key: true
  end
end
