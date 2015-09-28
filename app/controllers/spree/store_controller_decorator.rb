module Spree
  StoreController.class_eval do
    before_action :load_notifications

    private

    def load_notifications
      if signed_in?
        notifications = notifications_for(spree_current_user)
      else
        notifications = notifications_for(cookies.signed[:guest_token])
      end

      notifications.each do |notification|
        flash.now[notification.severity] = notification.message
      end
    end

    def notifications_for(guest_token)
      SpreeNotifications::Notification.for(guest_token)
    end
  end
end
