url = paper_url(department: paper.department, paper: paper)
feed.entry paper, published: paper.created_at, updated: paper.updated_at, url: url do |entry|
  entry.link rel: 'alternate', type: 'text/plain', href: paper_url(department: paper.department, paper: paper, format: :txt)
  entry.link rel: 'alternate', type: 'application/json', href: paper_url(department: paper.department, paper: paper, format: :json)
  entry.title "#{paper.title} (#{paper.reference})"
  entry.author do |author|
    author.name paper.department.short_name
    author.uri department_url(paper.department)
  end
  entry.category(term: paper.department.short_name, label: paper.department.subject)
end