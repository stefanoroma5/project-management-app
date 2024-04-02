class NotificationsController < ApplicationController
  def index
    # mostro solo le notifiche dell'utente loggato
    developer = Developer.find(current_developer.id)
    @notifications = developer.notifications.order(created_at: :desc)
  end

  def update
    @notification = Notification.find(params[:id])
    respond_to do |format|
      if @notification.update(notification_params)

        format.html { redirect_to notifications_url(@notifications)}
        format.json { render :show, status: :ok, location: @pnotifications }

      else

        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @notifications.errors, status: :unprocessable_entity }
      end
    end
  end

  def notification_params
    params.require(:notification).permit(:text, :read)
  end
end
