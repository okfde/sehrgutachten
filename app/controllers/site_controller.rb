class SiteController < ApplicationController
  def root
    @departments = Department.all
  end

  def imprint
  end
end
