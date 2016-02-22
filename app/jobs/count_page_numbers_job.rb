class CountPageNumbersJob < ApplicationJob

  def perform(paper)
    logger.info "Counting Pages of the Paper [#{paper.department.short_name} #{paper.reference}]"

    unless File.exist? paper.local_path
      fail "No local copy of the PDF of Paper [#{paper.department.short_name} #{paper.reference}] found"
    end

    count = Docsplit.extract_length paper.local_path
    paper.page_count = count
    paper.save
  end
end