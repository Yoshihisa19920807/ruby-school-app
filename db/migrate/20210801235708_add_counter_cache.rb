class AddCounterCache < ActiveRecord::Migration[6.1]
  def change
    add_column :courses, :lessons_count, :int, default: 0, null: false
    add_column :users, :courses_count, :int, default: 0, null: false
    add_column :users, :enrollments_count, :int, default: 0, null: false
  end
end
