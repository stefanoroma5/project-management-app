class Project < ApplicationRecord
  belongs_to :developer
  has_many :task
  has_many :developer_projects
  has_many :developers, through: :developer_projects

  validates :title,
    presence: true
  validates :deadline,
    presence: true
  validates :customer,
    presence: true,
    format: {with: /\A[a-zA-Z\s]+\z/, message: "only allows letters and spaces"}
  validates :description,
    presence: true
  validate :start_date_cannot_be_in_the_past, :end_date_cannot_be_in_the_past, :deadline_cannot_be_in_the_past, :start_date_has_to_be_smaller_than_deadline, :end_date_has_to_be_greater_than_start_date

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

  def deadline_cannot_be_in_the_past
    if deadline.present? && deadline < Date.today
      errors.add(:deadline, "can't be in the past")
    end
  end

  def start_date_has_to_be_smaller_than_deadline
    if start_date.present? && deadline < start_date
      errors.add(:start_date, "can't be after deadline")
    end
  end

  def end_date_has_to_be_greater_than_start_date
    if end_date.present? && start_date > end_date
      errors.add(:end_date, "can't be earlier than start date")
    end
  end

  scope :unstarted, -> { where(status: "Unstarted") }
  scope :started, -> { where(status: "Started") }
  scope :finished, -> { where(status: "Finished") }

  scope :recent, ->(*args) {
                   where("start_date > ?",
                     (args.first || 2.weeks.ago))
                 }

  scope :overdue, -> { where(status: "Started").where("deadline < ?", Date.today) }

  scope :owner, ->(*args) { where("developer_id = ?", args.first) }
  scope :collaborate, ->(*args) {Project.joins(:developer_projects).where("developer_projects.developer_id = ?", args.first)}
end
