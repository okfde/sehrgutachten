require 'test_helper'

class SiteControllerTest < ActionDispatch::IntegrationTest
  test "should get root" do
    get root_url
    assert_response :success
  end

  test "should get imprint" do
    get imprint_url
    assert_response :success
  end

end
