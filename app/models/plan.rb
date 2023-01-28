class Plan < ApplicationRecord
  belongs_to :user
  validates :plan_day_of_week, presence: true
  validates :plan_time_hour, presence: true
  validates :plan_time_minute, presence: true
end
