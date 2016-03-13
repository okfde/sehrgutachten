class PaperController < ApplicationController
  before_action :find_department
  before_action :find_paper
  before_action :redirect_old_slugs
  before_action :check_active_push_ocr_token, only: [:update]

  def show
    respond_to do |format|
      format.html
      format.pdf { redirect_to @paper.url }
      format.txt { render plain: @paper.contents }
      format.json
    end
  end

  def update
    if request.body.blank? || request.body.size < 1
      head(400)
      return
    end

    @paper.contents = request.body.read.force_encoding('utf-8').strip
    @paper.save
    redirect_to paper_path(@department, @paper, format: :txt)
  end

  private

  def find_department
    @department = Department.friendly.find params[:department]
  end

  def find_paper
    begin
      @paper = @department.papers.friendly.find params[:paper]
    rescue ActiveRecord::RecordNotFound => e
      if params[:paper] =~ /\A(\d+\-\d+)/
        return find_paper_by_reference Regexp.last_match[1].gsub('-', '/')
      end
      raise e
    end
  end

  def find_paper_by_reference(reference)
    @paper = @department.papers.where(reference: reference).first
    fail ActiveRecord::RecordNotFound if @paper.nil?
  end

  def redirect_old_slugs
    canonical_path = paper_path(@department, @paper, format: mime_extension(request.format))
    if request.path != canonical_path
      return redirect_to canonical_path, status: :moved_permanently
    end
  end

  def check_active_push_ocr_token
    if Rails.configuration.x.push_ocr_token.blank?
      render status: :unauthorized
      return
    end

    authenticate_or_request_with_http_token do |token, options|
      ActiveSupport::SecurityUtils.variable_size_secure_compare(Rails.configuration.x.push_ocr_token, token)
    end
  end
end
