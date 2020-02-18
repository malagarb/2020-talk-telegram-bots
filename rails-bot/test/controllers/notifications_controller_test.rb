require 'test_helper'

class NotificationsControllerTest < ActionDispatch::IntegrationTest
  test "should get webhook" do
    get notifications_webhook_url
    assert_response :success
  end

end
