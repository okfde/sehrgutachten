module ApplicationHelper
  def link_to_paper(title, paper, html_options = {})
    link_to title, paper_path(paper.department, paper), html_options
  end
end
