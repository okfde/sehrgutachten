class PaperController < ApplicationController
  before_filter :find_department
  before_filter :find_paper

  def show
  end

  private

  def find_department
    @department = Department.friendly.find params[:department]
  end

  def find_paper
    @paper = @department.papers.find params[:paper]
  end
end
