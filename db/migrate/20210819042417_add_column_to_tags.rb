class AddColumnToTags < ActiveRecord::Migration[6.1]
  def change
    add_column :tags, :course_tags_count, :int, null: false, default: 0
  end
end
