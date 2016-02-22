require 'test_helper'

class DepartmentControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get department_url(departments(:wd1))
    assert_response :success
  end

end
