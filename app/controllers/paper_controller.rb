class PaperController < ApplicationController
  before_action :find_department
  before_action :find_paper
  before_action :redirect_old_slugs

  def show
  end

  private

  def find_department
    @department = Department.friendly.find params[:department]
  end

  def find_paper
    @paper = @department.papers.friendly.find params[:paper]
  end

  def redirect_old_slugs
    canonical_path = paper_path(@department, @paper)
    if request.path != canonical_path
      return redirect_to canonical_path, status: :moved_permanently
    end
  end
end
