FactoryGirl.define do
  factory :notification, class: SpreeNotifications::Notification do
    severity "warn"
    message "Warning! Warning!"
    guest_token SecureRandom.urlsafe_base64(nil, false)

    trait :guest

    trait :registered_user do
      guest_token nil
      user
    end
  end
end
