class CreateSpreeNotificationsNotifications < ActiveRecord::Migration
  def change
    create_table :spree_notifications_notifications do |t|
      t.string :severity
      t.text :message
      t.string :guest_token
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
