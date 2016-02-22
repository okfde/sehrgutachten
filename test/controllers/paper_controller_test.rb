require 'test_helper'

class PaperControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get paper_url(departments(:wd1), papers(:one))
    assert_response :success
  end

end
