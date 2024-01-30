class Label < ApplicationRecord
  has_many :tasks_labels
  has_many :tasks, through: :tasks_labels

  validates :name,
    presence: true

  scope :recent, ->(*args) {
    where("created_at > ?",
      (args.first || 2.weeks.ago))
  }
end
