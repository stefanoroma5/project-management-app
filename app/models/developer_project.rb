class DeveloperProject < ApplicationRecord
  belongs_to :developer
  belongs_to :project

  validates :email,
    presence: true
  validates :status,
    presence: true,
    inclusion: {in: %w[Active Inactive], message: "%{value} is not a valid status"}
end
