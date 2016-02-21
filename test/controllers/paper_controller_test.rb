require 'test_helper'

class PaperControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get paper_show_url
    assert_response :success
  end

end
