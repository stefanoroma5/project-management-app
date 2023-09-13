class Project < ApplicationRecord
  validates :title, presence: true
  validates :deadline, presence: true
  validates :customer, presence: true
  validates :description, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
end
