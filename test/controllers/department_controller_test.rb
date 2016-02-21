require 'test_helper'

class DepartmentControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get department_show_url
    assert_response :success
  end

end
