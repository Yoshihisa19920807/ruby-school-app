class AddImpressionToUserLesson < ActiveRecord::Migration[6.1]
  def change
    add_column :user_lessons, :impressions, :int, default: 0, null: false
  end
end
