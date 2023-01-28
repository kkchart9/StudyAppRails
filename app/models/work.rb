class Work < ApplicationRecord
  belongs_to :user
  validates :work_date, presence: true
  validates :work_time_minute, presence: true
  validates :work_time_hour, presence: true
end
