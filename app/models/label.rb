class Label < ApplicationRecord
  has_and_belongs_to_many :tasks

  validates :name,
    presence: true

  scope :recent, ->(*args) {
    where("created_at > ?",
      (args.first || 2.weeks.ago))
  }
end
