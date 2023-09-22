class Task < ApplicationRecord
  validates :description,
    presence: true
  validates :title,
    presence: true
  validates :end_date,
    presence: true,
    comparison: {greater_than: :start_date}
  validate :start_date_cannot_be_in_the_past, :end_date_cannot_be_in_the_past

  def start_date_cannot_be_in_the_past
    if start_date.present? && start_date < Date.today
      errors.add(:start_date, "can't be in the past")
    end
  end

  def end_date_cannot_be_in_the_past
    if end_date.present? && end_date < Date.today
      errors.add(:end_date, "can't be in the past")
    end
  end

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
