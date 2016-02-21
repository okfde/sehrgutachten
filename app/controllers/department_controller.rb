class DepartmentController < ApplicationController
  before_filter :find_department

  def show
    @papers = @department.papers
              .order(created_at: :desc)
              .page params[:page]
  end

  private

  def find_department
    @department = Department.friendly.find params[:department]
  end
end
