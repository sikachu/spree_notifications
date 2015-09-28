require "spec_helper"

RSpec.describe Spree::StoreController do
  include Devise::TestHelpers

  controller do
    def index
      render text: flash.to_hash.map { |key, value| "#{key}: #{value}" }.join
    end
  end

  before do
    create(:notification, :guest, guest_token: guest_token, message: "Guest!")
    create(:notification, :guest, message: "Nope!")
    create(:notification, :registered_user, message: "User!")
  end

  let(:guest_token) do
    get :index
    cookies.signed[:guest_token]
  end

  context "when user is not logged in" do
    it "loads notification based on the guest token" do
      get :index

      expect(response.body).to include "Guest!"
      expect(response.body).not_to include "Nope!"
      expect(response.body).not_to include "User!"
    end
  end

  context "when user is logged in" do
    it "loads notification based on user" do
      sign_in Spree::User.last

      get :index

      expect(response.body).not_to include "Guest!"
      expect(response.body).not_to include "Nope!"
      expect(response.body).to include "User!"
    end
  end
end
