module ApplicationHelper
  def link_to_paper(title, paper, html_options = {})
    link_to title, paper_path(paper.department, paper), html_options
  end

  def display_header_search?
    !current_page?(root_path) && !current_page?(search_path)
  end

  def feed_url_with_current_page(model, params = {})
    options = params.merge(only_path: false, format: :atom)
    options[:page] = model.current_page if model.current_page > 1
    url_for(options)
  end

  def paginated_feed(feed, model, params = {})
    options = params.merge(only_path: false, format: :atom)
    unless model.first_page?
      prev_url = if model.prev_page == 1
                   url_for(options)
                 else
                   url_for(options.merge(page: model.prev_page))
                 end
      feed.link(rel: 'prev', type: 'application/atom+xml', href: prev_url)
    end
    unless model.last_page?
      next_url = url_for(options.merge(page: model.next_page))
      feed.link(rel: 'next', type: 'application/atom+xml', href: next_url)
    end
  end
end
