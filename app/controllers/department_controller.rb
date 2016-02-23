class DepartmentController < ApplicationController
  before_action :find_department

  def show
    @papers = @department.papers
              .order(created_at: :desc, reference: :desc)
              .page params[:page]
    fresh_when last_modified: @papers.maximum(:updated_at), public: true
  end

  private

  def find_department
    @department = Department.friendly.find params[:department]
  end
end
