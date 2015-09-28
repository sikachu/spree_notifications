require "spec_helper"

RSpec.describe SpreeNotifications do
  describe ".create" do
    it "creates SpreeNotifications::Notification database record" do
      allow(SpreeNotifications::Notification).to receive(:create!)

      SpreeNotifications.create(:warn, "message", guest_token: "token")

      expect(SpreeNotifications::Notification).
        to have_received(:create!).
          with(severity: "warn", message: "message", guest_token: "token")
    end
  end
end
