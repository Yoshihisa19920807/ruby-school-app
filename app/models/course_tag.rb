class CourseTag < ApplicationRecord
  belongs_to :tag, counter_cache: true
  belongs_to :course

  accepts_nested_attributes_for :tag, reject_if: :all_blank
end
