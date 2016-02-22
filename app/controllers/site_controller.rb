class SiteController < ApplicationController
  def root
    @departments = Department.all
    @count = Paper.count.round(-1)
  end

  def imprint
  end
end
