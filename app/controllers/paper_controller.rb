class PaperController < ApplicationController
  before_action :find_department
  before_action :find_paper

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
