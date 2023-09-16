class Task < ApplicationRecord
  validates :description, presence: true
  validates :title, presence: true

  scope :feature, -> { where(task_type: "Feature") }
  scope :chore, -> { where(task_type: "Chore") }
  scope :bug, -> { where(task_type: "Bug") }

  scope :unstarted, -> { where(state: "Unstarted") }
  scope :started, -> { where(state: "Started") }
  scope :finished, -> { where(state: "Finished") }

  scope :p1, -> { where(priority: "P1") }
  scope :p2, -> { where(priority: "P2") }
  scope :p1, -> { where(priority: "P3") }
end
