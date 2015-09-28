require "spec_helper"

RSpec.feature "Background notification" do
  scenario "displays as flash message to guest" do
    SpreeNotifications.create(
      :warn,
      "Something is happening!",
      guest_token: guest_token
    )

    visit spree.root_path

    expect(page).
      to have_selector(".alert-warn", text: "Something is happening!")
  end

  scenario "displays as flash message to registered user" do
    user = create(:user)
    sign_in_as user
    SpreeNotifications.create(
      :warn,
      "Something is happening!",
      user_id: user.id
    )

    visit spree.root_path

    expect(page).
      to have_selector(".alert-warn", text: "Something is happening!")
  end

  def guest_token
    # Visit a page so Spree will generate a guest token in cookie
    visit spree.root_path
    cookie_jar.signed["guest_token"]
  end

  def cookie_jar
    ActionDispatch::Cookies::CookieJar.build(page.driver.request).tap do |jar|
      jar.update(page.driver.browser.rack_mock_session.cookie_jar.to_hash)
    end
  end
end
