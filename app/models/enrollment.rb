class Enrollment < ApplicationRecord
  belongs_to :user
  belongs_to :course
  # user_idとcopurse_idの組み合わせが重複するレコードの作成を禁止
  validates :user_id, uniqueness: { scope: :course_id }
end
