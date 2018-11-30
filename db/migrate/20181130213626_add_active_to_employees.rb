class AddActiveToEmployees < ActiveRecord::Migration[5.2]
  def change
    add_column :employees, :active, :boolean, default: true
  end
end
