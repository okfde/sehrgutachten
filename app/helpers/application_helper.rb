module ApplicationHelper
  def link_to_paper(title, paper, html_options = {})
    link_to title, paper_path(paper.department, paper), html_options
  end

  def display_header_search?
    !current_page?(root_path) && !current_page?(search_path)
  end
end
