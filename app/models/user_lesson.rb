class UserLesson < ApplicationRecord
    belongs_to :user, counter_cache: true
    belongs_to :lesson, counter_cache: true

    validates :lesson_id, uniqueness: { scope: :user_id }
end
