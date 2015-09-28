class SpreeNotifications::Notification < ActiveRecord::Base
  belongs_to :user, class_name: Spree::User

  validates :severity, :message, presence: true
  validate :validates_presence_of_either_guest_token_or_user_id

  def self.for(guest_token_or_user)
    if guest_token_or_user.respond_to?(:id)
      where(user_id: guest_token_or_user.id)
    else
      where(guest_token: guest_token_or_user)
    end
  end

  private

  def validates_presence_of_either_guest_token_or_user_id
    if guest_token.blank? && user_id.blank?
      errors.add(:base, "both guest_token and user_id can't be blank")
    end
  end
end
