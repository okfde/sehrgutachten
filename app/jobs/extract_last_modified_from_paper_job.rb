class ExtractLastModifiedFromPaperJob < ApplicationJob
  def perform(paper)
    logger.info "Extracting Last-Modified from Paper [#{paper.department.short_name} #{paper.reference}]"

    last_modified = extract_local(paper)

    fail "Can't extract text from Paper [#{paper.department.short_name} #{paper.reference}]" if last_modified.blank?

    paper.last_modified = DateTime.parse(last_modified)
    paper.save!
  end

  def extract_local(paper)
    fail "No local copy of the PDF of Paper [#{paper.department.short_name} #{paper.reference}] found" unless File.exist?(paper.local_path)

    Docsplit.extract_date(paper.local_path)
  end
end