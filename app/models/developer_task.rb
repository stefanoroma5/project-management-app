class DeveloperTask < ApplicationRecord
  belongs_to :developer
  belongs_to :task
end
