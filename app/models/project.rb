class Project < ApplicationRecord

  belongs_to :developer
  has_many :task
  has_and_belongs_to_many :developers

  validates :title,
    presence: true
  validates :deadline,
    presence: true,
    comparison: {greater_than: :start_date}
  validates :customer,
    presence: true,
    format: {with: /\A[a-zA-Z\s]+\z/, message: "only allows letters and spaces"}
  validates :description,
    presence: true
  validates :start_date,
    presence: true,
    comparison: {less_than: :deadline}
  validates :end_date,
    presence: true,
    comparison: {greater_than: :start_date}
  validate :start_date_cannot_be_in_the_past, :end_date_cannot_be_in_the_past, :deadline_cannot_be_in_the_past

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

  scope :unstarted, -> { where(status: "Unstarted") }
  scope :started, -> { where(status: "Started") }
  scope :finished, -> { where(status: "Finished") }
end
