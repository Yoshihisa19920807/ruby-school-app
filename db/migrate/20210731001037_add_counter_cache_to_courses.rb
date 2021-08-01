class AddCounterCacheToCourses < ActiveRecord::Migration[6.1]
  def change
    add_column :courses, :enrollments_count, :int, default:0, null:false
  end
end
