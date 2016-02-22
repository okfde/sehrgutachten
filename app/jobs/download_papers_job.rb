class DownloadPapersJob < ApplicationJob
  def perform(paper, options = {})
    options.reverse_merge!(force: false)

    logger.info "Downloading PDF for Paper [#{paper.department.short_name} #{paper.reference}]"

    if File.exist?(paper.local_path) && !options[:force]
      logger.info "PDF for Paper [#{paper.department.short_name} #{paper.reference}] already exists in storage"
      return
    end

    ret = download_paper(paper)
    fail "Downloading Paper [#{paper.department.short_name} #{paper.reference}] failed" unless ret

    CountPageNumbersJob.perform_later(paper) if paper.page_count.blank? || options[:force]
    ExtractTextFromPaperJob.perform_later(paper) if paper.contents.blank? || options[:force]
    # ExtractLastModifiedFromPaperJob.perform_later(paper) if paper.pdf_last_modified.blank?
  end

  def patron_session
    sess = Patron::Session.new
    sess.connect_timeout = 5
    sess.timeout = 60
    sess.headers['User-Agent'] = Rails.configuration.x.user_agent
    sess
  end

  def download_paper(paper)
    session = patron_session
    filepath = paper.local_path
    folder = filepath.dirname
    FileUtils.mkdir_p folder

    resp = session.get(paper.url)

    if resp.status != 200
      logger.warn "Download failed with status #{resp.status} for Paper [#{paper.department.short_name} #{paper.reference}]"
      return false
    end

    content_type = content_type(resp)

    if content_type.split(';').first.downcase != 'application/pdf'
      logger.warn "File for Paper [#{paper.department.short_name} #{paper.reference}] is not a PDF: #{content_type}"
      return false
    end

    last_modified = resp.headers.try(:[], 'Last-Modified')

    f = File.open(filepath, 'wb')
    begin
      f.write(resp.body)
    rescue
      logger.warn "Cannot write file for Paper [#{paper.department.short_name} #{paper.reference}]"
      return false
    ensure
      f.close if f
    end

    paper.last_modified = DateTime.parse(last_modified) unless last_modified.blank?
    paper.downloaded_at = DateTime.now if paper.downloaded_at.nil?
    paper.save

    true
  end

  def content_type(response)
    content_type = response.headers['Content-Type']
    if content_type.is_a? Array
      content_type.last
    else
      content_type
    end
  end
end