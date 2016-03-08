class SiteController < ApplicationController
  def root
    @departments = Department.all.order(id: :asc)
    @count = Paper.count.round(-1)
  end

  def imprint
  end

  def faq
  end

  def recent
    @papers = Paper
              .order(created_at: :desc, reference: :desc)
              .page params[:page]
    fresh_when last_modified: @papers.maximum(:updated_at), public: true
  end

  def status
    expires_now
    render text: "OK - #{Time.now}"
  end
end
