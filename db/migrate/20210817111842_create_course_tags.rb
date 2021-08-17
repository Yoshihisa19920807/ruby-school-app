class CreateCourseTags < ActiveRecord::Migration[6.1]
  def change
    create_table :course_tags do |t|
      t.belongs_to :course
      t.belongs_to :tag

      t.timestamps
    end
  end
end
