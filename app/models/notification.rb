class Notification < ApplicationRecord
  belongs_to :developer

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