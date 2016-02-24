url = paper_url(department: paper.department, paper: paper)
feed.entry paper, published: paper.created_at, updated: paper.updated_at, url: url do |entry|
  # items like in html search result

  title = details[:highlight].try(:fetch, :title, nil).try(:html_safe) || paper.title

  title = "#{title} (#{paper.reference})"

  snippet = details[:highlight].try(:fetch, :contents, nil) || ''
  snippet += '&hellip;' unless snippet.blank?

  entry.title do
    feed.cdata! title
  end

  entry.author do |author|
    author.name paper.department.short_name
    author.uri department_url(paper.department)
  end

  entry.category(term: paper.department.short_name, label: paper.department.subject)

  unless snippet.blank?
    entry.summary do
      feed.cdata! snippet
    end
  end
end