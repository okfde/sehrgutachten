class ImportNewPapersJob < ApplicationJob

  def perform
    papers = WdAusarbeitungenScraper.scrape_all

    old_papers = 0
    new_papers = 0
    papers.each do |item|
      new_paper = false
      department = Department.find_by_short_name(item[:department])
      if department.nil?
        logger.error "Unknown department: #{item[:department]}, Paper: [#{item[:reference]}] \"#{item[:title]}\""
        next
      end

      if Paper.where(department: department, reference: item[:reference]).exists?
        paper = Paper.where(department: department, reference: item[:reference]).first
        old_papers += 1
        logger.info "[#{department.short_name}] Updating Paper: [#{item[:reference]}] \"#{item[:title]}\""
        paper.assign_attributes(item.except(:department, :reference))
        paper.save!
      else
        logger.info "[#{department.short_name}] New Paper: [#{item[:reference]}] \"#{item[:title]}\""
        item[:department] = department
        paper = Paper.create(item)
        new_papers += 1
      end

      # DownloadPaperJob.perform_later(paper, force: new_paper) unless paper.url.blank?
    end

    logger.info "Importing done. #{new_papers} new Papers, #{old_papers} old Papers."
  end

end