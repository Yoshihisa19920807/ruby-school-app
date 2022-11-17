class AddColumnToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :user_lessons_count, :int, default: 0, null: false
    add_column :lessons, :user_lessons_count, :int, default: 0, null: false
  end
end
