class CourseTag < ApplicationRecord
  belongs_to :tag
  belongs_to :course

  accepts_nested_attributes_for :tag, reject_if: :all_blank
end
