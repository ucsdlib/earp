class AllowEmployeesWithoutManagers < ActiveRecord::Migration[5.2]
  def change
    change_column_null :employees, :manager, true
  end
end
