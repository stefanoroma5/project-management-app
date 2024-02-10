class DeveloperProject < ApplicationRecord
  belongs_to :developer
  belongs_to :project

  validates :email,
    presence: true
  validates :status,
    presence: true,
    inclusion: {in: %w[Unstarted Started Finished], message: "%{value} is not a valid status"}
end
