class SiteController < ApplicationController
  def root
    @departments = Department.all
    @count = Paper.count.round(-1)
  end

  def imprint
  end

  def recent
    @papers = Paper
              .order(created_at: :desc, reference: :desc)
              .page params[:page]
    fresh_when last_modified: @papers.maximum(:updated_at), public: true
  end
end
