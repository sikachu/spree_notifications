require "spec_helper"

RSpec.describe SpreeNotifications::Notification do
  it { should belong_to :user }

  it { should validate_presence_of :severity }
  it { should validate_presence_of :message }

  describe "#validate" do
    context "with both guest_token and user_id are nil" do
      it "fails the validation" do
        notification = build(:notification, guest_token: nil, user_id: nil)

        expect(notification).not_to be_valid
        expect(notification.errors[:base]).
          to eq ["both guest_token and user_id can't be blank"]
      end
    end

    context "with only guest_token given" do
      it "passes the validation" do
        notification = build(:notification, :guest, guest_token: "ABCDE")

        expect(notification).to be_valid
      end
    end

    context "with only user_id given" do
      it "passes the validation" do
        user = build_stubbed(:user)
        notification = build(:notification, :registered_user, user_id: user.id)

        expect(notification).to be_valid
      end
    end
  end

  describe ".for" do
    context "with a guest token" do
      it "returns all notifications associated with that guest_token" do
        guest_notification = create(:notification, :guest, guest_token: "ABCDE")
        user_notification = create(:notification, :registered_user)

        expect(SpreeNotifications::Notification.for("ABCDE")).
          to eq [guest_notification]
      end
    end

    context "with a user object" do
      it "returns all notifications associated with that user" do
        guest_notification = create(:notification, :guest)
        user_notification = create(:notification, :registered_user)

        expect(SpreeNotifications::Notification.for(user_notification.user)).
          to eq [user_notification]
      end
    end
  end
end
