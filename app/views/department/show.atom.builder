atom_feed(
  language:  'de-DE',
  root_url: department_url(department: @department, format: :atom),
  url: feed_url_with_current_page(@papers)
) do |feed|
  paginated_feed(feed, @papers)
  feed.title "sehrgutachten: Gutachten des #{@department.short_name}"
  feed.updated @papers.maximum(:updated_at)
  feed.author { |author| author.name 'sehrgutachten' }

  @papers.each do |paper|
    render(partial: 'paper/paper', locals: { feed: feed, paper: paper })
  end
end