class Notification < ApplicationRecord
  belongs_to :developer

  validates :text,
    presence: true
  validates :read,
    presence: true,
    inclusion: {in: [true, false], message: "%{value} is not valid"}

  scope :unread, -> { where(read: false) }
  scope :read, -> { where(read: true) }
  scope :recent, ->(*args) {
    where("created_at > ?",
      (args.first || 2.weeks.ago))
  }

  def self.check_deadlines
    projects = Project.all
    projects.each do |project|
      if project.deadline == Date.today
        developer = Developer.find(project.developer_id)
        @notification = developer.notifications.build(text: "ALARM! Deadline for the project " + @project.title + " is over", read: false)
        @notification.save
      end
    end
  end
end
