class NotificationsController < ApplicationController

  def index
    # mostro solo le notifiche dell'utente loggato
    developer = Developer.find(current_developer.id)
    @notifications = developer.notifications
  end

end
