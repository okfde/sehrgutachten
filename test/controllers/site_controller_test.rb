require 'test_helper'

class SiteControllerTest < ActionDispatch::IntegrationTest
  test "should get root" do
    get site_root_url
    assert_response :success
  end

  test "should get imprint" do
    get site_imprint_url
    assert_response :success
  end

end
