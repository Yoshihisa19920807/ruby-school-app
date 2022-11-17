class AddIncomeToCourses < ActiveRecord::Migration[6.1]
  def change
    add_column :courses, :income, :int, null: false, default: 0
  end
end
