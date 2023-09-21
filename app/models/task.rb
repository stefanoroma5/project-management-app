class Task < ApplicationRecord
  validates :description, presence: true
  validates :title, presence: true

  scope :feature, -> { where(task_type: "Feature") }
  scope :chore, -> { where(task_type: "Chore") }
  scope :bug, -> { where(task_type: "Bug") }
  scope :release, -> { where(task_type: "Release") }

  scope :unstarted, -> { where(status: "Unstarted") }
  scope :started, -> { where(status: "Started") }
  scope :finished, -> { where(status: "Finished") }

  scope :p1, -> { where(priority: "P1") }
  scope :p2, -> { where(priority: "P2") }
  scope :p1, -> { where(priority: "P3") }
end
