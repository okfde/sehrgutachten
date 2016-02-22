class ImportNewPapersJob < ApplicationJob

  def perform(department)
    papers = WdAusarbeitungenScraper.scrape_department(department.source_url)

    old_papers = 0
    new_papers = 0
    papers.each do |item|
      new_paper = false
      if Paper.where(department: department, reference: item[:reference], title: item[:title]).exists?
        paper = Paper.where(department: department, reference: item[:reference], title: item[:title]).first
        old_papers += 1
        logger.info "[#{department.short_name}] Updating Paper: [#{item[:reference]}] \"#{item[:title]}\""
        paper.assign_attributes(item.except(:reference))
        paper.save!
      else
        logger.info "[#{department.short_name}] New Paper: [#{item[:reference]}] \"#{item[:title]}\""
        item[:department] = department
        paper = Paper.create(item)
        new_papers += 1
      end

      DownloadPaperJob.perform_later(paper, force: new_paper) unless paper.url.blank?
    end

    logger.info "Importing done. #{new_papers} new Papers, #{old_papers} old Papers."
  end

end