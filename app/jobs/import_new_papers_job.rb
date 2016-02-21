class ImportNewPapersJob < ApplicationJob

  def perform(department)
    papers = WdAusarbeitungenScraper.scrape_department(department.source_url)

    old_papers = 0
    new_papers = 0
    papers.each do |paper|
      if Paper.where(department: department, reference: paper[:reference], title: paper[:title]).exists?
        old_papers += 1
        next
      end

      paper[:department] = department
      Paper.create(paper)
      new_papers += 1
    end

    logger.info "Importing done. #{new_papers} new Papers, #{old_papers} old Papers."
  end

end