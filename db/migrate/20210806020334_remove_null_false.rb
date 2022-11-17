class RemoveNullFalse < ActiveRecord::Migration[6.1]
  def change
    change_column_null :courses, :user_id, true
    # change_column_null :lessons, :user_id, true
    change_column_null :user_lessons, :user_id, true
    change_column_null :comments, :user_id, true
  end
end
