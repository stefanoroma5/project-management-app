class Task < ApplicationRecord
  belongs_to :project
  has_many :developer_tasks
  has_many :developers, through: :developer_tasks
  has_many :tasks_labels
  has_many :labels, through: :tasks_labels

  validates :description,
    presence: true
  validates :title,
    presence: true
  validates :task_type,
    presence: true,
    inclusion: {in: %w[Feature Chore Bug Release], message: "%{value} is not a valid task type"}
  validates :status,
    presence: true,
    inclusion: {in: %w[Unstarted Started Finished], message: "%{value} is not a valid status"}
  validates :priority,
    inclusion: {in: %w[Low Medium High], message: "%{value} is not a valid priority"}
  validate :start_date_cannot_be_in_the_past, :end_date_cannot_be_in_the_past, :end_date_has_to_be_greater_than_start_date

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

  def end_date_has_to_be_greater_than_start_date
    if start_date.present? && end_date.present? && start_date > end_date
      errors.add(:end_date, "can't be earlier than start date")
    end
  end

  scope :feature, -> { where(task_type: "Feature") }
  scope :chore, -> { where(task_type: "Chore") }
  scope :bug, -> { where(task_type: "Bug") }
  scope :release, -> { where(task_type: "Release") }

  scope :unstarted, -> { where(status: "Unstarted") }
  scope :started, -> { where(status: "Started") }
  scope :finished, -> { where(status: "Finished") }

  scope :low, -> { where(priority: "Low") }
  scope :medium, -> { where(priority: "Medium") }
  scope :high, -> { where(priority: "High") }

  scope :recent, ->(*args) {
                   where("start_date > ?",
                     (args.first || 2.weeks.ago))
                 }
end
